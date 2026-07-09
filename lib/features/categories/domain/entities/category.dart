import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

/// Whether a category applies to money out or money in. Persisted as [value]
/// in `categories.type`.
enum CategoryType {
  expense('expense'),
  income('income');

  const CategoryType(this.value);

  final String value;

  static CategoryType fromValue(String? value) => CategoryType.values
      .firstWhere((t) => t.value == value, orElse: () => CategoryType.expense);
}

/// A spending / income category. Supports one level of hierarchy via
/// [parentId] (a top-level category has `parentId == null`). Pure domain
/// entity — icon is a catalog key `String`, color an ARGB `int` (rule 19).
@freezed
abstract class Category with _$Category {
  const factory Category({
    required String name,
    required CategoryType type,

    /// `null` until persisted (AUTOINCREMENT assigns it on insert).
    int? id,

    /// Parent category id; `null` for a top-level category.
    int? parentId,

    /// [AppIcons] catalog key.
    String? icon,

    /// ARGB color value.
    int? color,
    @Default(0) int sortOrder,
    @Default(false) bool archived,
    @Default(0) int createdAt,
  }) = _Category;
}
