import 'package:jaga_saku/features/categories/domain/entities/category.dart';

/// Shared reconcile "Penyesuaian" pair fixtures — the reserved system categories
/// every report surface must exclude. One definition so the home / insight /
/// money-story / calendar / aggregator suites all pin the SAME system category
/// (mirrors the real v6 seed: name 'Penyesuaian', matched by [Category.systemKey]).

/// The expense side of the reconcile pair (`adjustment_out`, id 8).
const penyesuaianOut = Category(
  id: 8,
  name: 'Penyesuaian',
  type: CategoryType.expense,
  systemKey: 'adjustment_out',
);

/// The income side of the reconcile pair (`adjustment_in`, id 9).
const penyesuaianIn = Category(
  id: 9,
  name: 'Penyesuaian',
  type: CategoryType.income,
  systemKey: 'adjustment_in',
);
