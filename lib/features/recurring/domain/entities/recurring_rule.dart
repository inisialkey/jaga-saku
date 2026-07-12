import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';

part 'recurring_rule.freezed.dart';

/// How often a recurring rule fires. Persisted as its [value] string in
/// `recurring.freq` (mirrors `TransactionType`, `transaction.dart:8-25` — no raw
/// strings in the entity).
enum RecurrenceFreq {
  daily('daily'),
  weekly('weekly'),
  monthly('monthly'),
  yearly('yearly');

  const RecurrenceFreq(this.value);

  /// Stored representation (the `freq` column value).
  final String value;

  /// Maps a stored string back to the enum, defaulting to [monthly] for an
  /// unknown / legacy value (never throws).
  static RecurrenceFreq fromValue(String? value) =>
      RecurrenceFreq.values.firstWhere(
        (f) => f.value == value,
        orElse: () => RecurrenceFreq.monthly,
      );
}

/// A recurring schedule (V2-M5): a `tx_templates` shape (`is_favorite = 0`) plus
/// a cadence. Pure domain entity — ids are plain `int`s, all dates are
/// midnight-local epoch millis (rule 19, no Flutter / data types cross this
/// boundary; the cross-feature [TxTemplate] domain import is allowed).
///
/// - [startDate] is the first occurrence AND the anchor for month/year clamping
///   (Jan-31 monthly walks 31 → Feb-28 → Mar-31); never lose it.
/// - [nextDue] is the idempotency cursor: the earliest UNRESOLVED occurrence. It
///   only ever moves forward (on confirm / skip), never rewinds.
/// - [template] is non-persisted — join-filled by `getRules()`, `null` on a
///   plain read / insert (mirrors `Budget.spent`, `budget.dart:29`).
@freezed
abstract class RecurringRule with _$RecurringRule {
  const factory RecurringRule({
    /// The owned `tx_templates` row id (the FK target). `0` until the two-table
    /// insert assigns it.
    required int templateId,
    required RecurrenceFreq freq,

    /// First occurrence + the day-of-month/weekday anchor, midnight-local millis.
    required int startDate,

    /// Cursor: earliest UNRESOLVED occurrence, midnight-local millis.
    required int nextDue,

    /// `null` until persisted (SQLite AUTOINCREMENT assigns it on insert).
    int? id,

    /// Every N units (every 2 months, every 3 weeks, …).
    @Default(1) int interval,

    /// Optional inclusive last bound; `null` = open-ended.
    int? endDate,
    @Default(0) int createdAt,

    /// Non-persisted: the joined `tx_templates` shape, filled by `getRules()`;
    /// `null` on a plain read / insert.
    TxTemplate? template,
  }) = _RecurringRule;
}

/// A projected, not-yet-written occurrence for the review UI (V2-M5). Carries
/// the full [rule] (so the anchor-aware cursor advance has freq / interval /
/// startDate / id) and the resolved [template] (hoisted from `rule.template` so
/// confirm needs no `!`), at the true [dueDate].
@freezed
abstract class PendingOccurrence with _$PendingOccurrence {
  const factory PendingOccurrence({
    required RecurringRule rule,
    required TxTemplate template,
    required int dueDate,
  }) = _PendingOccurrence;
}
