import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/recurrence_schedule.dart';

/// Pure-helper contract (rule 19): occurrence math with the anchor-aware clamp.
/// No Flutter / DB / clock — the correctness gate for the whole milestone (C1).
void main() {
  /// Midnight-local millis for a calendar day, matching how the helper rebuilds
  /// every result.
  int at(int y, int m, int d) => DateTime(y, m, d).millisecondsSinceEpoch;

  int next(int from, RecurrenceFreq freq, int interval, int start) =>
      RecurrenceSchedule.nextOccurrence(from, freq, interval, startDate: start);

  group('nextOccurrence — daily / weekly', () {
    final start = at(2025, 1, 31);

    test('daily interval 1 adds a day', () {
      expect(
        next(at(2025, 1, 31), RecurrenceFreq.daily, 1, start),
        at(2025, 2, 1),
      );
    });

    test('daily interval N adds N days (across a month boundary)', () {
      expect(
        next(at(2025, 1, 31), RecurrenceFreq.daily, 3, start),
        at(2025, 2, 3),
      );
    });

    test('weekly interval 1 adds 7 days', () {
      expect(
        next(at(2025, 1, 31), RecurrenceFreq.weekly, 1, start),
        at(2025, 2, 7),
      );
    });

    test('weekly interval N adds 7*N days', () {
      expect(
        next(at(2025, 1, 31), RecurrenceFreq.weekly, 2, start),
        at(2025, 2, 14),
      );
    });
  });

  group('nextOccurrence — monthly anchor clamp (C1 heart)', () {
    // A Jan-31 monthly rule must walk 31 → Feb-28 → **Mar-31** (anchor restored,
    // NOT Mar-28), then Apr-30 → May-31.
    final start = at(2025, 1, 31);

    test('Jan-31 → Feb-28 (short month clamps to the anchor)', () {
      expect(
        next(at(2025, 1, 31), RecurrenceFreq.monthly, 1, start),
        at(2025, 2, 28),
      );
    });

    test('Feb-28 → Mar-31 (anchor restored, not Mar-28)', () {
      expect(
        next(at(2025, 2, 28), RecurrenceFreq.monthly, 1, start),
        at(2025, 3, 31),
      );
    });

    test('Mar-31 → Apr-30 → May-31 (full anchored walk)', () {
      expect(
        next(at(2025, 3, 31), RecurrenceFreq.monthly, 1, start),
        at(2025, 4, 30),
      );
      expect(
        next(at(2025, 4, 30), RecurrenceFreq.monthly, 1, start),
        at(2025, 5, 31),
      );
    });

    test('monthly interval 2 keeps the anchor (Jan-31 → Mar-31 → May-31)', () {
      final n1 = next(at(2025, 1, 31), RecurrenceFreq.monthly, 2, start);
      expect(n1, at(2025, 3, 31));
      expect(next(n1, RecurrenceFreq.monthly, 2, start), at(2025, 5, 31));
    });

    test('crossing a year boundary (Dec → Jan next year)', () {
      final decStart = at(2025, 12, 31);
      expect(
        next(at(2025, 12, 31), RecurrenceFreq.monthly, 1, decStart),
        at(2026, 1, 31),
      );
    });
  });

  group('nextOccurrence — yearly Feb-29 clamp', () {
    // Feb-29-2024 (leap) → Feb-28-2025 → Feb-28-2026 → Feb-28-2027 → Feb-29-2028
    // (anchor restored in the next leap year).
    final start = at(2024, 2, 29);

    test('Feb-29-2024 → Feb-28-2025', () {
      expect(
        next(at(2024, 2, 29), RecurrenceFreq.yearly, 1, start),
        at(2025, 2, 28),
      );
    });

    test('walks back to Feb-29 in the leap year 2028', () {
      var cur = at(2024, 2, 29);
      cur = next(cur, RecurrenceFreq.yearly, 1, start); // 2025-02-28
      cur = next(cur, RecurrenceFreq.yearly, 1, start); // 2026-02-28
      cur = next(cur, RecurrenceFreq.yearly, 1, start); // 2027-02-28
      cur = next(cur, RecurrenceFreq.yearly, 1, start); // 2028-02-29
      expect(cur, at(2028, 2, 29));
    });
  });

  group('dueOccurrences', () {
    test('a 3-month gap yields 3 monthly dates (inclusive of until)', () {
      final start = at(2025, 1, 15);
      final dates = RecurrenceSchedule.dueOccurrences(
        cursor: start,
        until: at(2025, 3, 20),
        freq: RecurrenceFreq.monthly,
        interval: 1,
        startDate: start,
      );
      expect(dates, [at(2025, 1, 15), at(2025, 2, 15), at(2025, 3, 15)]);
    });

    test('excludes occurrences past endDate', () {
      final start = at(2025, 1, 15);
      final dates = RecurrenceSchedule.dueOccurrences(
        cursor: start,
        until: at(2025, 3, 20),
        freq: RecurrenceFreq.monthly,
        interval: 1,
        startDate: start,
        endDate: at(2025, 2, 20),
      );
      expect(dates, [at(2025, 1, 15), at(2025, 2, 15)]);
    });

    test('empty when cursor is after until', () {
      final dates = RecurrenceSchedule.dueOccurrences(
        cursor: at(2025, 5, 1),
        until: at(2025, 4, 1),
        freq: RecurrenceFreq.daily,
        interval: 1,
        startDate: at(2025, 5, 1),
      );
      expect(dates, isEmpty);
    });

    test('caps an overflowing span at exactly cap items', () {
      final start = at(2020, 1, 1);
      final dates = RecurrenceSchedule.dueOccurrences(
        cursor: start,
        until: at(2020, 12, 31),
        freq: RecurrenceFreq.daily,
        interval: 1,
        startDate: start,
        cap: 5,
      );
      expect(dates, hasLength(5));
      expect(dates.first, at(2020, 1, 1));
      expect(dates.last, at(2020, 1, 5));
    });
  });

  group('firstDueOnOrAfter (C5 cursor reset)', () {
    test(
      'a past monthly start floored at today returns the first on/after',
      () {
        final start = at(2025, 1, 15);
        expect(
          RecurrenceSchedule.firstDueOnOrAfter(
            startDate: start,
            floor: at(2025, 3, 15),
            freq: RecurrenceFreq.monthly,
            interval: 1,
          ),
          at(2025, 3, 15),
        );
      },
    );

    test('never returns a date before the floor', () {
      final start = at(2025, 1, 15);
      final result = RecurrenceSchedule.firstDueOnOrAfter(
        startDate: start,
        floor: at(2025, 3, 20),
        freq: RecurrenceFreq.monthly,
        interval: 1,
      );
      expect(result >= at(2025, 3, 20), isTrue);
      expect(result, at(2025, 4, 15));
    });

    test('a future start returns the start unchanged', () {
      final start = at(2030, 1, 1);
      expect(
        RecurrenceSchedule.firstDueOnOrAfter(
          startDate: start,
          floor: at(2025, 3, 20),
          freq: RecurrenceFreq.monthly,
          interval: 1,
        ),
        start,
      );
    });
  });

  test('deterministic — identical inputs give identical output (no clock)', () {
    final start = at(2025, 1, 31);
    final a = next(at(2025, 2, 28), RecurrenceFreq.monthly, 1, start);
    final b = next(at(2025, 2, 28), RecurrenceFreq.monthly, 1, start);
    expect(a, b);
    expect(a, at(2025, 3, 31));
  });
}
