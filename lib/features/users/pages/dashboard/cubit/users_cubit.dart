import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/users/users.dart';
part 'users_cubit.freezed.dart';

/// Paginated users list. Accumulates [User] items across pages; [loadMore]
/// is guarded against firing while a fetch is in flight or when there is no
/// next page.
class UsersCubit extends Cubit<UsersState> {
  UsersCubit(this._getUsers) : super(const UsersState.initial());

  final GetUsers _getUsers;

  int _page = 1;
  String? _search;
  bool _isFetching = false;

  /// Resets pagination and loads page 1 (optionally filtered by [search]).
  Future<void> fetchFirstPage({String? search}) async {
    _search = (search == null || search.isEmpty) ? null : search;
    _page = 1;
    emit(const UsersState.loading());
    await _fetch(reset: true);
  }

  /// Re-fetches page 1 with the current search term.
  Future<void> refresh() async {
    _page = 1;
    await _fetch(reset: true);
  }

  /// Applies a new [query] and reloads from page 1.
  Future<void> search(String query) => fetchFirstPage(search: query);

  /// Loads the next page and appends to the accumulated list. No-op while a
  /// fetch is in flight or when the loaded page has no next page.
  Future<void> loadMore() async {
    final current = state;
    if (current is! UsersStateLoaded) return;
    if (_isFetching || !current.page.meta.hasNext) return;

    _page = current.page.meta.page + 1;
    emit(current.copyWith(isLoadingMore: true));
    await _fetch(reset: false);
  }

  Future<void> _fetch({required bool reset}) async {
    if (_isFetching) return;
    _isFetching = true;

    final previousItems = switch (state) {
      UsersStateLoaded(:final items) => items,
      _ => const <User>[],
    };

    final result = await _getUsers.call(
      GetUsersParams(page: _page, search: _search),
    );
    _isFetching = false;
    if (isClosed) return;

    result.fold((failure) => emit(UsersState.failure(failure)), (page) {
      final items = reset ? page.items : [...previousItems, ...page.items];
      if (items.isEmpty) {
        emit(const UsersState.empty());
        return;
      }
      emit(UsersState.loaded(page: page, items: items));
    });
  }
}

@freezed
sealed class UsersState with _$UsersState {
  const factory UsersState.initial() = UsersStateInitial;
  const factory UsersState.loading() = UsersStateLoading;
  const factory UsersState.loaded({
    required Page<User> page,
    required List<User> items,
    @Default(false) bool isLoadingMore,
  }) = UsersStateLoaded;
  const factory UsersState.empty() = UsersStateEmpty;
  const factory UsersState.failure(Failure failure) = UsersStateFailure;
}
