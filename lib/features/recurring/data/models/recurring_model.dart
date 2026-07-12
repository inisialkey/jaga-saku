import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';

part 'recurring_model.freezed.dart';

/// Data-layer row model for the `recurring` table. Maps are hand-written (no
/// `json_serializable`) because the shape is a SQLite row, not JSON: [freq] maps
/// to its string [RecurrenceFreq.value], dates are midnight-local rupiah-style
/// `INTEGER` millis, and `template_id` links the owned `tx_templates` row.
///
/// The non-persisted `RecurringRule.template` (join-filled by the datasource)
/// has no column here — [toEntity] leaves it `null`; the datasource sets it via
/// `copyWith` after reading the joined template row.
@freezed
abstract class RecurringModel with _$RecurringModel {
  const factory RecurringModel({
    required int templateId,
    required RecurrenceFreq freq,
    required int startDate,
    required int nextDue,
    int? id,
    @Default(1) int interval,
    int? endDate,
    @Default(0) int createdAt,
  }) = _RecurringModel;

  const RecurringModel._();

  factory RecurringModel.fromMap(Map<String, Object?> map) => RecurringModel(
    id: map['id'] as int?,
    templateId: (map['template_id'] as int?) ?? 0,
    freq: RecurrenceFreq.fromValue(map['freq'] as String?),
    interval: (map['interval'] as int?) ?? 1,
    startDate: (map['start_date'] as int?) ?? 0,
    endDate: map['end_date'] as int?,
    nextDue: (map['next_due'] as int?) ?? 0,
    createdAt: (map['created_at'] as int?) ?? 0,
  );

  factory RecurringModel.fromEntity(RecurringRule rule) => RecurringModel(
    id: rule.id,
    templateId: rule.templateId,
    freq: rule.freq,
    interval: rule.interval,
    startDate: rule.startDate,
    endDate: rule.endDate,
    nextDue: rule.nextDue,
    createdAt: rule.createdAt,
  );

  /// Column map for insert/update. Omits `id` when null so AUTOINCREMENT fires;
  /// `template_id` is written by the datasource on insert (it isn't known until
  /// the template row lands), but is included here for the update path.
  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'template_id': templateId,
    'freq': freq.value,
    'interval': interval,
    'start_date': startDate,
    'end_date': endDate,
    'next_due': nextDue,
    'created_at': createdAt,
  };

  /// Does NOT set `template` — the datasource fills it via `copyWith` from the
  /// joined `tx_templates` row.
  RecurringRule toEntity() => RecurringRule(
    id: id,
    templateId: templateId,
    freq: freq,
    interval: interval,
    startDate: startDate,
    endDate: endDate,
    nextDue: nextDue,
    createdAt: createdAt,
  );
}
