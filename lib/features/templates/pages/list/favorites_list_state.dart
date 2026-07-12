part of 'favorites_list_cubit.dart';

/// State machine for the favorites list. `loaded` carries the ordered favorite
/// set (all `is_favorite = 1`).
@freezed
sealed class FavoritesListState with _$FavoritesListState {
  const factory FavoritesListState.initial() = FavoritesListInitial;

  const factory FavoritesListState.loading() = FavoritesListLoading;

  const factory FavoritesListState.loaded({required List<TxTemplate> items}) =
      FavoritesListLoaded;

  const factory FavoritesListState.error(Failure failure) = FavoritesListError;
}
