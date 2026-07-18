//coverage:ignore-file
import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/localization/generated/strings.dart';
import 'package:jaga_saku/core/localization/generated/strings_en.dart';
import 'package:jaga_saku/core/localization/generated/strings_id.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_cycle.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/budgets/domain/usecases/get_budgets_for_period.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/get_due_occurrences.dart';
import 'package:jaga_saku/features/reminders/data/reminder_local_datasource.dart';
import 'package:jaga_saku/features/reminders/data/reminder_routes.dart';
import 'package:jaga_saku/features/reminders/domain/entities/reminder_config.dart';
import 'package:jaga_saku/features/reminders/domain/entities/reminder_decisions.dart';
import 'package:jaga_saku/features/reminders/domain/entities/reminder_type.dart';
import 'package:jaga_saku/features/reminders/domain/usecases/check_budget_warnings.dart';
import 'package:jaga_saku/features/reminders/domain/usecases/reconcile_reminders.dart';
import 'package:timezone/timezone.dart' as tz;

/// The reminder edge (V3-M5) — the ONLY layer that touches
/// `flutter_local_notifications` + `timezone`. All decisions are made by the
/// pure usecases (`ReconcileReminders` / `CheckBudgetWarnings`); this class just
/// reads config, fetches the derived surfaces (`GetDueOccurrences` /
/// `GetBudgetsForPeriod` / `GetCategories`), and applies the plan through the
/// plugin. App-lifetime DI singleton — it subscribes once to [TxChangeNotifier]
/// for the live budget-warning path and is never disposed.
///
/// `//coverage:ignore-file`: this is the untestable MethodChannel / `tz` seam;
/// every branch of the logic it orchestrates is unit-tested in the pure usecases
/// + datasource (plan §8).
class ReminderService {
  ReminderService({
    required ReminderLocalDatasource datasource,
    required ReconcileReminders reconcileReminders,
    required CheckBudgetWarnings checkBudgetWarnings,
    required GetDueOccurrences getDueOccurrences,
    required GetBudgetsForPeriod getBudgetsForPeriod,
    required GetCategories getCategories,
    required TxChangeNotifier txChanges,
  }) : _datasource = datasource,
       _reconcileReminders = reconcileReminders,
       _checkBudgetWarnings = checkBudgetWarnings,
       _getDueOccurrences = getDueOccurrences,
       _getBudgetsForPeriod = getBudgetsForPeriod,
       _getCategories = getCategories,
       _txChanges = txChanges;

  final ReminderLocalDatasource _datasource;
  final ReconcileReminders _reconcileReminders;
  final CheckBudgetWarnings _checkBudgetWarnings;
  final GetDueOccurrences _getDueOccurrences;
  final GetBudgetsForPeriod _getBudgetsForPeriod;
  final GetCategories _getCategories;
  final TxChangeNotifier _txChanges;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// One high-importance channel for every reminder (single-channel decision).
  static const String _channelId = 'jaga_saku_reminders';
  static const String _channelName = 'Reminders';

  StreamSubscription<void>? _txSub;

  /// Bootstrap: create the Android channel, init the plugin (with the tap
  /// callback), subscribe once to the tx bus for the live budget path, and
  /// route a cold-launch tap after the first frame. `tz` MUST already be
  /// initialized by `main()` before any [reconcile]/[rescheduleDaily].
  Future<void> init() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            importance: Importance.high,
          ),
        );

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // Permission is requested in-context on first toggle (better grant
        // rate), never at boot — so suppress the Darwin init-time prompt.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: _onTap,
    );

    // App-lifetime subscription (never cancelled — DI singleton). A tx / budget
    // write pings the bus → re-check current-period budget crossings live.
    _txSub ??= _txChanges.changes.listen(
      (_) => unawaited(recomputeBudgetWarnings()),
    );

    // Cold launch by a notification tap: the router isn't mounted yet at init(),
    // so route once the first frame is up. The M4 lock gate wins if locked.
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      final payload = launch?.notificationResponse?.payload;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => appRouter.go(routeForReminderPayload(payload)),
      );
    }
  }

  /// Requests the OS notification permission for the current platform. Returns
  /// `true` when granted. Called from the cubit on the first toggle-on.
  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission() ??
          false;
    }
    if (Platform.isIOS) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    }
    return false;
  }

  /// App-open catch-up: reads config, folds the three pure decisions into one
  /// plan and applies it. Nothing enabled → cancel everything and bail (so a
  /// disabled app leaves no orphaned schedules).
  Future<void> reconcile() async {
    final config = await _datasource.readConfig();
    if (!config.dailyEnabled &&
        !config.recurringDueEnabled &&
        !config.budgetWarningEnabled) {
      await _plugin.cancelAll();
      return;
    }
    final now = DateTime.now();
    final due = await _fetchDue();
    final budgets = await _fetchCurrentBudgets(now);
    final warnedMarkers = await _readWarnedMarkers(budgets);
    final plan = _reconcileReminders(
      config: config,
      due: due,
      budgets: budgets,
      warnedMarkers: warnedMarkers,
      now: now,
    );
    await _applyDaily(plan.daily);
    await _applyRecurring(plan.recurring);
    await _applyBudgetWarnings(plan.budgetWarnings);
  }

  /// A daily change (toggle or time) re-runs the full catch-up — cheap and
  /// idempotent (stable ids), so one primitive keeps every leg consistent.
  Future<void> rescheduleDaily() => reconcile();

  /// A recurring-due toggle re-runs the same idempotent catch-up.
  Future<void> syncRecurring() => reconcile();

  /// The live budget-warning path (tx-bus ping + the budget toggle): fire a
  /// notification for every current-period crossing not yet warned this period.
  Future<void> recomputeBudgetWarnings() async {
    final config = await _datasource.readConfig();
    if (!config.budgetWarningEnabled) return;
    final now = DateTime.now();
    final budgets = await _fetchCurrentBudgets(now);
    final warnedMarkers = await _readWarnedMarkers(budgets);
    final warnings = _checkBudgetWarnings(
      enabled: true,
      budgets: budgets,
      now: now,
      warnedMarkers: warnedMarkers,
    );
    await _applyBudgetWarnings(warnings);
  }

  /// Cancels the tx-bus subscription. Production never calls this — the DI
  /// singleton lives for the whole app — so the subscription is app-lifetime by
  /// design; this exists purely so it is formally cancellable (and for tests).
  Future<void> dispose() async {
    await _txSub?.cancel();
    _txSub = null;
  }

  void _onTap(NotificationResponse response) =>
      appRouter.go(routeForReminderPayload(response.payload));

  Future<void> _applyDaily(DailyReminderDecision decision) async {
    final id = ReminderType.dailyCheckIn.notificationId();
    if (!decision.schedule) {
      await _plugin.cancel(id: id);
      return;
    }
    final s = await _strings();
    await _schedule(
      id: id,
      title: s.reminderNotifTitle,
      body: s.reminderDailyNotifBody,
      fireAtMillis: decision.firstFireAtMillis!,
      payload: ReminderType.dailyCheckIn.name,
      // Repeat daily at the same clock time.
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _applyRecurring(RecurringReminderDecision decision) async {
    final id = ReminderType.recurringDue.notificationId();
    if (!decision.schedule) {
      await _plugin.cancel(id: id);
      return;
    }
    final s = await _strings();
    await _schedule(
      id: id,
      title: s.reminderNotifTitle,
      body: s.reminderRecurringNotifBody,
      fireAtMillis: decision.fireAtMillis!,
      payload: ReminderType.recurringDue.name,
      // One-shot on the due date; refreshed on each app-open reconcile.
      matchDateTimeComponents: null,
    );
  }

  Future<void> _applyBudgetWarnings(List<BudgetWarning> warnings) async {
    if (warnings.isEmpty) return;
    final s = await _strings();
    final names = await _expenseCategoryNames();
    for (final warning in warnings) {
      final name = names[warning.categoryId] ?? '';
      final body = warning.level == BudgetStatusLevel.critical
          ? s.reminderBudgetOverNotifBody(name)
          : s.reminderBudgetNearNotifBody(name);
      await _show(
        id: ReminderType.budgetWarning.notificationId(
          budgetId: warning.budgetId,
        ),
        title: s.reminderNotifTitle,
        body: body,
        payload: ReminderType.budgetWarning.name,
      );
      await _datasource.markWarned(warning.markerKey);
    }
  }

  Future<List<PendingOccurrence>> _fetchDue() async {
    final result = await _getDueOccurrences(NoParams());
    return result.fold((_) => <PendingOccurrence>[], (list) => list);
  }

  /// The current cycle's budgets, using the same period math the app does
  /// (`BudgetCycle.range` → `periodKey(cycle.start)`), so markers + fetch align
  /// with the Budget screen.
  Future<List<Budget>> _fetchCurrentBudgets(DateTime now) async {
    final startDay = await _datasource.readBudgetCycleStartDay();
    final cycle = BudgetCycle.range(startDay: startDay, reference: now);
    final period = periodKey(DateTime.fromMillisecondsSinceEpoch(cycle.start));
    final result = await _getBudgetsForPeriod(period);
    return result.fold((_) => <Budget>[], (list) => list);
  }

  /// The already-warned marker set for [budgets] — probes both levels per budget
  /// (using the budget's own `period`, matching `CheckBudgetWarnings`' key).
  Future<Set<String>> _readWarnedMarkers(List<Budget> budgets) async {
    final warned = <String>{};
    for (final budget in budgets) {
      final id = budget.id;
      if (id == null) continue;
      for (final level in const [
        BudgetStatusLevel.warning,
        BudgetStatusLevel.critical,
      ]) {
        final key = ReminderConfig.budgetMarkerKey(id, budget.period, level);
        if (await _datasource.isWarned(key)) warned.add(key);
      }
    }
    return warned;
  }

  Future<Map<int, String>> _expenseCategoryNames() async {
    final result = await _getCategories(CategoryType.expense);
    final categories = result.fold((_) => <Category>[], (list) => list);
    return {
      for (final category in categories)
        if (category.id != null) category.id!: category.name,
    };
  }

  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required int fireAtMillis,
    required String payload,
    required DateTimeComponents? matchDateTimeComponents,
  }) => _plugin.zonedSchedule(
    id: id,
    scheduledDate: tz.TZDateTime.from(
      DateTime.fromMillisecondsSinceEpoch(fireAtMillis),
      tz.local,
    ),
    notificationDetails: _details(),
    // Inexact (decision 3): no SCHEDULE_EXACT_ALARM; may drift under Doze.
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    title: title,
    body: body,
    payload: payload,
    matchDateTimeComponents: matchDateTimeComponents,
  );

  Future<void> _show({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) => _plugin.show(
    id: id,
    title: title,
    body: body,
    notificationDetails: _details(),
    payload: payload,
  );

  NotificationDetails _details() => const NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  /// Notification copy without a `BuildContext`: resolves the persisted locale;
  /// unset / `system` defaults to Indonesian (the app's primary locale).
  Future<Strings> _strings() async {
    final code = await _datasource.readLocaleCode();
    return code == 'en' ? StringsEn() : StringsId();
  }
}
