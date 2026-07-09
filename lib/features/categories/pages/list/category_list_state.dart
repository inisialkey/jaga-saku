part of 'category_list_cubit.dart';

/// State machine for the categories list. Every non-initial state carries the
/// active [CategoryType] so the tab selector stays put across loads. `loaded`
/// holds the flat set for the type (including archived); the page filters and
/// groups it into parent -> child.
@freezed
sealed class CategoryListState with _$CategoryListState {
  const factory CategoryListState.initial() = CategoryListInitial;

  const factory CategoryListState.loading({
    @Default(CategoryType.expense) CategoryType type,
  }) = CategoryListLoading;

  const factory CategoryListState.loaded({
    required List<Category> items,
    required CategoryType type,
    @Default(false) bool showArchived,
  }) = CategoryListLoaded;

  const factory CategoryListState.error({
    required Failure failure,
    @Default(CategoryType.expense) CategoryType type,
  }) = CategoryListError;
}
