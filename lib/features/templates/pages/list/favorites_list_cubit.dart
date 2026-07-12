import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/templates/domain/usecases/delete_tx_template.dart';
import 'package:jaga_saku/features/templates/domain/usecases/get_favorites.dart';
import 'package:jaga_saku/features/templates/domain/usecases/reorder_templates.dart';

part 'favorites_list_cubit.freezed.dart';
part 'favorites_list_state.dart';

/// Drives the favorites list: load, hard-delete and drag reorder. Simpler than
/// the accounts list it mirrors — `tx_templates` is a leaf table so a delete is
/// always a clean hard-delete (no archive fallback) and there is no visible /
/// hidden split. Failures fold into [FavoritesListError]; the widget localizes
/// them (rule 17). Every emit is guarded by [isClosed] (rule 5).
class FavoritesListCubit extends Cubit<FavoritesListState> {
  FavoritesListCubit({
    required GetFavorites getFavorites,
    required DeleteTxTemplate deleteTemplate,
    required ReorderTemplates reorderTemplates,
  }) : _getFavorites = getFavorites,
       _deleteTemplate = deleteTemplate,
       _reorderTemplates = reorderTemplates,
       super(const FavoritesListState.initial());

  final GetFavorites _getFavorites;
  final DeleteTxTemplate _deleteTemplate;
  final ReorderTemplates _reorderTemplates;

  Future<void> load() async {
    emit(const FavoritesListState.loading());
    final result = await _getFavorites(NoParams());
    if (isClosed) return;
    emit(
      result.fold(
        FavoritesListState.error,
        (items) => FavoritesListState.loaded(items: items),
      ),
    );
  }

  /// Hard-deletes the favorite (leaf table — never FK-blocked), then reloads.
  Future<void> delete(int id) async {
    final result = await _deleteTemplate(id);
    if (isClosed) return;
    final failure = result.getLeft().toNullable();
    if (failure != null) {
      emit(FavoritesListState.error(failure));
    } else {
      await load();
    }
  }

  /// Optimistically renders the new order (no loading flash), then persists it;
  /// reverts to the DB's authoritative order if the write fails. [newIndex] is
  /// already adjusted for the removed item (ReorderableListView `onReorderItem`).
  Future<void> reorder(int oldIndex, int newIndex) async {
    final s = state;
    if (s is! FavoritesListLoaded) return;
    final items = [...s.items];
    final moved = items.removeAt(oldIndex);
    items.insert(newIndex, moved);
    emit(FavoritesListState.loaded(items: items));
    final ids = [
      for (final t in items)
        if (t.id != null) t.id!,
    ];
    final saved = await _reorderTemplates(ids);
    if (isClosed) return;
    if (saved.isLeft()) await load();
  }
}
