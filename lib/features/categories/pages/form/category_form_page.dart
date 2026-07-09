import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/pages/form/category_form_cubit.dart';

/// Navigation payload for the category form route (`extra`). Either edit an
/// existing [category], or create a new one — optionally pre-filled with a
/// [presetType] / [presetParentId] when adding a child from a parent row.
class CategoryFormArgs {
  const CategoryFormArgs({this.category, this.presetType, this.presetParentId});

  final Category? category;
  final CategoryType? presetType;
  final int? presetParentId;
}

/// Create / edit category form. Owns the name controller (rule 7); other state
/// lives in [CategoryFormCubit]. Pops with `true` on a successful save.
class CategoryFormPage extends StatefulWidget {
  const CategoryFormPage({super.key});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: context.read<CategoryFormCubit>().state.name,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return BlocConsumer<CategoryFormCubit, CategoryFormState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == CategoryFormStatus.success) {
          context.pop(true);
        } else if (state.status == CategoryFormStatus.failure &&
            state.error != null) {
          state.error!.localize(context).toToastError(context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<CategoryFormCubit>();
        return AppScaffold(
          appBar: AppBar(
            leading: const CloseButton(),
            title: Text(state.isEditing ? s.editCategory : s.addCategory),
          ),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _FieldLabel(s.categoryType),
              SegmentedControl<CategoryType>(
                selected: state.type,
                onChanged: cubit.typeChanged,
                options: [
                  SegmentOption(value: CategoryType.expense, label: s.expense),
                  SegmentOption(value: CategoryType.income, label: s.income),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              _FieldLabel(s.categoryName),
              TextField(
                controller: _nameController,
                onChanged: cubit.nameChanged,
                textCapitalization: TextCapitalization.words,
                decoration: _inputDecoration(context, hint: s.categoryName),
              ),
              const SizedBox(height: AppSpacing.xl),
              _FieldLabel(s.parentCategory),
              SelectorField(
                label: s.parentCategory,
                value: state.selectedParent?.name ?? s.none,
                onTap: () => _pickParent(context),
              ),
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: CategoryIconAvatar(
                  icon: state.icon,
                  color: state.color,
                  size: 64,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SelectorField(
                label: s.icon,
                icon: AppIcons.resolve(state.icon),
                onTap: () => _pickIcon(context),
              ),
              const SizedBox(height: AppSpacing.md),
              SelectorField(
                label: s.color,
                icon: Icons.palette_outlined,
                onTap: () => _pickColor(context),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: PrimaryButton(
                label: s.save,
                isLoading: state.isSaving,
                onPressed: state.isValid ? cubit.submit : null,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickParent(BuildContext context) async {
    final cubit = context.read<CategoryFormCubit>();
    final s = Strings.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => AppBottomSheet(
        title: s.parentCategory,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(s.none),
              onTap: () {
                cubit.parentChanged(null);
                Navigator.of(sheetContext).pop();
              },
            ),
            for (final parent in cubit.state.parentOptions)
              ListTile(
                leading: CategoryIconAvatar(
                  icon: parent.icon,
                  color: parent.color,
                  size: 32,
                ),
                title: Text(parent.name),
                onTap: () {
                  cubit.parentChanged(parent.id);
                  Navigator.of(sheetContext).pop();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickIcon(BuildContext context) async {
    final cubit = context.read<CategoryFormCubit>();
    final key = await IconPickerSheet.show(
      context,
      title: Strings.of(context)!.icon,
      selected: cubit.state.icon,
    );
    if (key != null) cubit.iconChanged(key);
  }

  Future<void> _pickColor(BuildContext context) async {
    final cubit = context.read<CategoryFormCubit>();
    final argb = await ColorPickerSheet.show(
      context,
      title: Strings.of(context)!.color,
      selected: cubit.state.color,
    );
    if (argb != null) cubit.colorChanged(argb);
  }
}

InputDecoration _inputDecoration(BuildContext context, {required String hint}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: context.colors.border),
  );
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Theme.of(context).cardColor,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: 14,
    ),
    border: border,
    enabledBorder: border,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: context.colors.textSecondary),
    ),
  );
}
