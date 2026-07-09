import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/archive_category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/delete_category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';
import 'package:jaga_saku/features/categories/domain/usecases/reorder_categories.dart';

part 'category_list_state.dart';
part 'category_list_cubit.freezed.dart';

/// Result of [CategoryListCubit.delete] the page acts on: a hard delete, or the
/// soft archive fallback taken when a delete is blocked (an in-use category in
/// M2). The page shows a soft "archived" toast for [archivedFallback].
enum DeleteOutcome { deleted, archivedFallback }

/// Drives the categories list per [CategoryType] tab: load, archive toggle,
/// per-item archive/delete and top-level drag reorder. Failures fold into
/// [CategoryListError]; the widget localizes them (rule 17).
class CategoryListCubit extends Cubit<CategoryListState> {
  CategoryListCubit({
    required GetCategories getCategories,
    required DeleteCategory deleteCategory,
    required ArchiveCategory archiveCategory,
    required ReorderCategories reorderCategories,
  }) : _getCategories = getCategories,
       _deleteCategory = deleteCategory,
       _archiveCategory = archiveCategory,
       _reorderCategories = reorderCategories,
       super(const CategoryListState.initial());

  final GetCategories _getCategories;
  final DeleteCategory _deleteCategory;
  final ArchiveCategory _archiveCategory;
  final ReorderCategories _reorderCategories;

  CategoryType _currentType = CategoryType.expense;

  Future<void> load([CategoryType? type]) async {
    final target = type ?? _currentType;
    _currentType = target;
    final showArchived = switch (state) {
      CategoryListLoaded(:final showArchived) => showArchived,
      _ => false,
    };
    emit(CategoryListState.loading(type: target));
    final result = await _getCategories(target);
    if (isClosed) return;
    emit(
      result.fold(
        (failure) => CategoryListState.error(failure: failure, type: target),
        (items) => CategoryListState.loaded(
          items: items,
          type: target,
          showArchived: showArchived,
        ),
      ),
    );
  }

  /// Switches the active tab, reloading that type from the DB.
  Future<void> selectType(CategoryType type) async {
    if (type == _currentType && state is CategoryListLoaded) return;
    await load(type);
  }

  void toggleArchived() {
    final s = state;
    if (s is CategoryListLoaded) {
      emit(s.copyWith(showArchived: !s.showArchived));
    }
  }

  Future<void> archive(int id, {required bool archived}) async {
    final result = await _archiveCategory(
      ArchiveCategoryParams(id: id, archived: archived),
    );
    if (isClosed) return;
    final failure = result.getLeft().toNullable();
    if (failure != null) {
      emit(CategoryListState.error(failure: failure, type: _currentType));
    } else {
      await load();
    }
  }

  Future<DeleteOutcome> delete(int id) async {
    final result = await _deleteCategory(id);
    if (isClosed) return DeleteOutcome.deleted;
    // ponytail: delete (and its cascade) always succeeds in M1. The Left path
    // is the M2 fallback — a delete blocked by a transaction FK archives the
    // category instead; the returned outcome lets the page surface a soft
    // "archived" notice.
    if (result.isLeft()) {
      await archive(id, archived: true);
      return DeleteOutcome.archivedFallback;
    }
    await load();
    return DeleteOutcome.deleted;
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final s = state;
    if (s is! CategoryListLoaded) return;
    final result = _reorderedTopLevel(
      s.items,
      showArchived: s.showArchived,
      oldIndex: oldIndex,
      newIndex: newIndex,
    );
    emit(s.copyWith(items: result.all));
    final saved = await _reorderCategories(result.visibleIds);
    if (isClosed) return;
    if (saved.isLeft()) await load();
  }

  /// Reorders only the visible top-level slice; children keep their order and
  /// hidden (archived) top-level rows are preserved.
  ///
  /// ponytail: child (sub-category) reorder is out of scope for M1 — only the
  /// top-level sibling group is reorderable. [newIndex] is already adjusted for
  /// the removed item (ReorderableListView `onReorderItem`).
  ({List<Category> all, List<int> visibleIds}) _reorderedTopLevel(
    List<Category> items, {
    required bool showArchived,
    required int oldIndex,
    required int newIndex,
  }) {
    bool visibleTop(Category c) =>
        c.parentId == null && (showArchived || !c.archived);

    final top = items.where(visibleTop).toList();
    final rest = items.where((c) => !visibleTop(c)).toList();
    final moved = top.removeAt(oldIndex);
    top.insert(newIndex, moved);
    return (
      all: [...top, ...rest],
      visibleIds: [
        for (final c in top)
          if (c.id != null) c.id!,
      ],
    );
  }
}
