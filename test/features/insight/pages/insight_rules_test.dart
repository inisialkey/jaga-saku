import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/insight/pages/insight_rules.dart';

/// Pure-engine tests (no widgets, no DB) — the correctness core of M5. Feeds
/// deterministic aggregated inputs and asserts exact fired items + thresholds.
void main() {
  List<InsightItem> run({
    List<BudgetGauge> budgets = const [],
    List<CategoryTrend> trends = const [],
    int currentUnplanned = 0,
    int previousUnplanned = 0,
  }) => computeInsights(
    budgets: budgets,
    categoryTrends: trends,
    currentUnplanned: currentUnplanned,
    previousUnplanned: previousUnplanned,
  );

  group('budget rule', () {
    test('fires at exactly 80% as a warning (boundary)', () {
      final items = run(
        budgets: const [BudgetGauge(categoryName: 'Kopi', percent: 80)],
      );
      expect(items, const [
        InsightItem(type: InsightType.warning, category: 'Kopi', pct: 80),
      ]);
    });

    test('does NOT fire at 79%', () {
      final items = run(
        budgets: const [BudgetGauge(categoryName: 'Kopi', percent: 79)],
      );
      expect(items, isEmpty);
    });

    test('uses critical copy at >= 100%', () {
      final items = run(
        budgets: const [BudgetGauge(categoryName: 'Kopi', percent: 120)],
      );
      expect(items.single.type, InsightType.critical);
      expect(items.single.category, 'Kopi');
      expect(items.single.pct, 120);
    });

    test('surfaces only the most-at-risk budget (max percent)', () {
      final items = run(
        budgets: const [
          BudgetGauge(categoryName: 'Makan', percent: 85),
          BudgetGauge(categoryName: 'Kopi', percent: 95),
        ],
      );
      expect(items.length, 1);
      expect(items.single.category, 'Kopi');
      expect(items.single.pct, 95);
    });
  });

  group('category month-over-month rule', () {
    test('fires for a riser >= 15% with a non-trivial increase', () {
      final items = run(
        trends: const [
          CategoryTrend(
            categoryName: 'Makan',
            current: 118000,
            previous: 100000,
          ),
        ],
      );
      expect(items, const [
        InsightItem(type: InsightType.trendUp, category: 'Makan', pct: 18),
      ]);
    });

    test('ignores a rise below 15%', () {
      final items = run(
        trends: const [
          CategoryTrend(
            categoryName: 'Makan',
            current: 110000,
            previous: 100000,
          ),
        ],
      );
      expect(items, isEmpty);
    });

    test('ignores a trivial-amount rise even at a high percent', () {
      // +500% but only +5.000 absolute — under the Rp10.000 floor.
      final items = run(
        trends: const [
          CategoryTrend(categoryName: 'Kopi', current: 6000, previous: 1000),
        ],
      );
      expect(items, isEmpty);
    });

    test('ignores a brand-new category (previous == 0, undefined %)', () {
      final items = run(
        trends: const [
          CategoryTrend(categoryName: 'Baru', current: 500000, previous: 0),
        ],
      );
      expect(items, isEmpty);
    });

    test('picks the largest riser by percent among several', () {
      final items = run(
        trends: const [
          CategoryTrend(
            categoryName: 'Makan',
            current: 118000,
            previous: 100000,
          ), // +18%
          CategoryTrend(
            categoryName: 'Belanja',
            current: 60000,
            previous: 40000,
          ), // +50%
        ],
      );
      expect(items.length, 1);
      expect(items.single.category, 'Belanja');
      expect(items.single.pct, 50);
    });
  });

  group('unplanned month-over-month rule', () {
    test('fires when this month > last month', () {
      final items = run(currentUnplanned: 500000, previousUnplanned: 300000);
      expect(items.single.type, InsightType.tip);
    });

    test('does NOT fire when equal', () {
      expect(run(currentUnplanned: 300000, previousUnplanned: 300000), isEmpty);
    });

    test('does NOT fire when lower', () {
      expect(run(currentUnplanned: 200000, previousUnplanned: 300000), isEmpty);
    });
  });

  test('all three fire in budget -> category -> unplanned order', () {
    final items = run(
      budgets: const [BudgetGauge(categoryName: 'Kopi', percent: 90)],
      trends: const [
        CategoryTrend(categoryName: 'Makan', current: 118000, previous: 100000),
      ],
      currentUnplanned: 500000,
      previousUnplanned: 300000,
    );
    expect(items.map((e) => e.type).toList(), [
      InsightType.warning,
      InsightType.trendUp,
      InsightType.tip,
    ]);
  });

  test('no rule fires -> empty list (gentle empty state upstream)', () {
    expect(run(), isEmpty);
  });
}
