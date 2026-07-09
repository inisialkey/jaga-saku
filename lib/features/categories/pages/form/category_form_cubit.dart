import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';
import 'package:jaga_saku/features/categories/domain/usecases/save_category.dart';

part 'category_form_state.dart';
part 'category_form_cubit.freezed.dart';

/// Backs the create/edit category form. Loads candidate parents for the picker,
/// seeds fields from [initial] when editing (or [presetType] / [presetParentId]
/// when adding a child), and folds [SaveCategory] into a status the page reacts
/// to.
class CategoryFormCubit extends Cubit<CategoryFormState> {
  CategoryFormCubit({
    required SaveCategory saveCategory,
    required GetCategories getCategories,
    Category? initial,
    CategoryType? presetType,
    int? presetParentId,
  }) : _saveCategory = saveCategory,
       _getCategories = getCategories,
       _initial = initial,
       super(
         initial == null
             ? CategoryFormState(
                 type: presetType ?? CategoryType.expense,
                 parentId: presetParentId,
               )
             : CategoryFormState(
                 type: initial.type,
                 name: initial.name,
                 parentId: initial.parentId,
                 icon: initial.icon,
                 color: initial.color,
                 isEditing: true,
               ),
       );

  final SaveCategory _saveCategory;
  final GetCategories _getCategories;
  final Category? _initial;

  /// Loads top-level, same-type categories as parent candidates (excludes self
  /// and archived rows).
  Future<void> loadParents() async {
    final result = await _getCategories(state.type);
    if (isClosed) return;
    result.fold(
      (failure) => log.e('CategoryForm.loadParents failed', error: failure),
      (categories) {
        final options = categories
            .where(
              (c) => c.parentId == null && !c.archived && c.id != _initial?.id,
            )
            .toList();
        emit(state.copyWith(parentOptions: options));
      },
    );
  }

  void typeChanged(CategoryType type) {
    if (type == state.type) return;
    // Switching type invalidates the parent (parents are same-type); rebuild the
    // state so parentId can be cleared to null (freezed copyWith can't null it).
    emit(
      CategoryFormState(
        type: type,
        name: state.name,
        icon: state.icon,
        color: state.color,
        isEditing: state.isEditing,
      ),
    );
    loadParents();
  }

  void nameChanged(String name) => emit(state.copyWith(name: name));

  void parentChanged(int? parentId) => emit(
    CategoryFormState(
      type: state.type,
      name: state.name,
      parentId: parentId,
      icon: state.icon,
      color: state.color,
      parentOptions: state.parentOptions,
      isEditing: state.isEditing,
    ),
  );

  void iconChanged(String? icon) => emit(state.copyWith(icon: icon));

  void colorChanged(int? color) => emit(state.copyWith(color: color));

  Future<void> submit() async {
    if (!state.isValid || state.isSaving) return;
    emit(state.copyWith(status: CategoryFormStatus.saving));

    // Built explicitly (not via copyWith) so a null parentId genuinely clears.
    final category = Category(
      id: _initial?.id,
      name: state.name.trim(),
      type: state.type,
      parentId: state.parentId,
      icon: state.icon,
      color: state.color,
      sortOrder: _initial?.sortOrder ?? 0,
      archived: _initial?.archived ?? false,
      createdAt: _initial?.createdAt ?? DateTime.now().millisecondsSinceEpoch,
    );

    final result = await _saveCategory(category);
    if (isClosed) return;
    emit(
      result.fold(
        (failure) =>
            state.copyWith(status: CategoryFormStatus.failure, error: failure),
        (_) => state.copyWith(status: CategoryFormStatus.success),
      ),
    );
  }
}
