import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_cycle.dart';

/// Pure cycle math (rule 19). The headline check is the backward-compat proof:
/// start-day 1 reproduces the EXACT calendar month, so every pre-M1 budget is
/// byte-identical. Also covers the payday (start-day 25) cycle, the short-month
/// day clamp, next/previous symmetry and determinism.
void main() {
  int ms(int y, int m, int d) => DateTime(y, m, d).millisecondsSinceEpoch;

  group('start-day 1 == calendar month (backward-compat)', () {
    test('January (mid-month reference)', () {
      final r = BudgetCycle.range(
        startDay: 1,
        reference: DateTime(2026, 1, 15),
      );
      expect(r.start, ms(2026, 1, 1));
      expect(r.end, ms(2026, 2, 1));
    });

    test('non-leap February', () {
      final r = BudgetCycle.range(
        startDay: 1,
        reference: DateTime(2026, 2, 10),
      );
      expect(r.start, ms(2026, 2, 1));
      expect(r.end, ms(2026, 3, 1));
    });

    test('leap February 2024 ends on 1 Mar', () {
      final r = BudgetCycle.range(
        startDay: 1,
        reference: DateTime(2024, 2, 29),
      );
      expect(r.start, ms(2024, 2, 1));
      expect(r.end, ms(2024, 3, 1));
    });

    test('December rolls the end into the next year', () {
      final r = BudgetCycle.range(
        startDay: 1,
        reference: DateTime(2026, 12, 31),
      );
      expect(r.start, ms(2026, 12, 1));
      expect(r.end, ms(2027, 1, 1));
    });
  });

  group('custom start-day 25 (payday cycle)', () {
    test('a reference before the 25th belongs to the previous cycle', () {
      final r = BudgetCycle.range(
        startDay: 25,
        reference: DateTime(2026, 7, 10),
      );
      expect(r.start, ms(2026, 6, 25));
      expect(r.end, ms(2026, 7, 25));
    });

    test('a reference after the 25th starts the current cycle', () {
      final r = BudgetCycle.range(
        startDay: 25,
        reference: DateTime(2026, 7, 28),
      );
      expect(r.start, ms(2026, 7, 25));
      expect(r.end, ms(2026, 8, 25));
    });

    test(
      'exactly on the start-day is inside the new cycle (half-open start)',
      () {
        final r = BudgetCycle.range(
          startDay: 25,
          reference: DateTime(2026, 7, 25),
        );
        expect(r.start, ms(2026, 7, 25));
        expect(r.end, ms(2026, 8, 25));
      },
    );
  });

  group('start-day clamp in short months', () {
    test('start-day 31 clamps a non-leap February end to the 28th', () {
      final r = BudgetCycle.range(
        startDay: 31,
        reference: DateTime(2026, 2, 15),
      );
      expect(r.start, ms(2026, 1, 31)); // Jan has a 31st
      expect(r.end, ms(2026, 2, 28)); // Feb clamps to the 28th
    });

    test('start-day 31 clamps a leap February end to the 29th', () {
      final r = BudgetCycle.range(
        startDay: 31,
        reference: DateTime(2024, 2, 20),
      );
      expect(r.start, ms(2024, 1, 31));
      expect(r.end, ms(2024, 2, 29));
    });

    test('start-day 31 clamps inside a 30-day month', () {
      // April has no 31st → the current start clamps to 30 Apr; the 15th
      // precedes it, so the containing cycle began 31 Mar.
      final r = BudgetCycle.range(
        startDay: 31,
        reference: DateTime(2026, 4, 15),
      );
      expect(r.start, ms(2026, 3, 31));
      expect(r.end, ms(2026, 4, 30));
    });
  });

  group('next / previous', () {
    test('next moves to the following cycle', () {
      // range(25, 10 Jul) = [25 Jun, 25 Jul); next = [25 Jul, 25 Aug).
      final n = BudgetCycle.next(
        startDay: 25,
        reference: DateTime(2026, 7, 10),
      );
      expect(n.start, ms(2026, 7, 25));
      expect(n.end, ms(2026, 8, 25));
    });

    test('previous moves to the preceding cycle', () {
      // range(25, 28 Jul) = [25 Jul, 25 Aug); previous = [25 Jun, 25 Jul).
      final p = BudgetCycle.previous(
        startDay: 25,
        reference: DateTime(2026, 7, 28),
      );
      expect(p.start, ms(2026, 6, 25));
      expect(p.end, ms(2026, 7, 25));
    });

    test('previous(next(x)) == x across a year boundary', () {
      final ref = DateTime(2026, 12, 20);
      const startDay = 15;
      final base = BudgetCycle.range(startDay: startDay, reference: ref);
      final next = BudgetCycle.next(startDay: startDay, reference: ref);
      final back = BudgetCycle.previous(
        startDay: startDay,
        reference: DateTime.fromMillisecondsSinceEpoch(next.start),
      );
      expect(back, base);
    });
  });

  test('deterministic: same inputs (incl. time-of-day) → same output', () {
    final a = BudgetCycle.range(
      startDay: 7,
      reference: DateTime(2026, 5, 3, 9, 30),
    );
    final b = BudgetCycle.range(
      startDay: 7,
      reference: DateTime(2026, 5, 3, 9, 30),
    );
    expect(a, b);
    expect(
      a.start,
      ms(2026, 4, 7),
    ); // 3 May precedes the 7th → cycle from 7 Apr
    expect(a.end, ms(2026, 5, 7));
  });
}
