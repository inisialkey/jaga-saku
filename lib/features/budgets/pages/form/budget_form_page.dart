import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/pages/form/budget_form_cubit.dart';
import 'package:jaga_saku/features/transactions/pages/widgets/category_picker_sheet.dart';

/// Navigation payload for the budget form route (`extra`). Either edit an
/// existing [initial] budget, or create a new one seeded to [month] (the list's
/// selected period).
class BudgetFormArgs {
  const BudgetFormArgs({this.initial, this.month});

  final Budget? initial;
  final DateTime? month;
}

/// Create / edit budget form. Owns the limit controller (rule 7); all other
/// state lives in [BudgetFormCubit]. Pops with `true` on a successful save so
/// the list reloads.
class BudgetFormPage extends StatefulWidget {
  const BudgetFormPage({super.key});

  @override
  State<BudgetFormPage> createState() => _BudgetFormPageState();
}

class _BudgetFormPageState extends State<BudgetFormPage> {
  late final TextEditingController _limitController;

  @override
  void initState() {
    super.initState();
    final state = context.read<BudgetFormCubit>().state;
    _limitController = TextEditingController(
      text: state.limitAmount == 0 ? '' : '${state.limitAmount}',
    );
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return BlocConsumer<BudgetFormCubit, BudgetFormState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == BudgetFormStatus.success) {
          context.pop(true);
        } else if (state.status == BudgetFormStatus.failure) {
          // D1: a save failure carries `error`; an invalid submit carries only
          // `firstError` — surface whichever applies.
          (state.error?.localize(context) ??
                  state.firstError?.localize(context) ??
                  s.errorUnexpected)
              .toToastError(context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<BudgetFormCubit>();
        return UnsavedChangesGuard(
          canLeave: !cubit.hasEdits || state.isSaving,
          child: AppScaffold(
            appBar: AppBar(
              leading: const CloseButton(),
              title: Text(state.isEditing ? s.editBudget : s.createBudget),
            ),
            body: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                FieldLabel(s.selectMonth),
                MonthSelector(
                  month: state.month,
                  onPrevious: cubit.previousMonth,
                  onNext: cubit.nextMonth,
                ),
                const SizedBox(height: AppSpacing.xl),
                FieldLabel(s.category),
                SelectorField(
                  label: state.selectedCategory?.name ?? s.selectCategory,
                  icon: state.selectedCategory == null
                      ? Icons.category_outlined
                      : AppIcons.resolve(state.selectedCategory!.icon),
                  onTap: () => _pickCategory(context),
                ),
                const SizedBox(height: AppSpacing.xl),
                FieldLabel(s.budgetLimit),
                AmountInputField(
                  controller: _limitController,
                  onChanged: (value) =>
                      cubit.limitChanged(int.tryParse(value) ?? 0),
                ),
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: PrimaryButton(
                  label: s.save,
                  isLoading: state.isSaving,
                  onPressed: cubit.submit,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickCategory(BuildContext context) async {
    final cubit = context.read<BudgetFormCubit>();
    final category = await CategoryPickerSheet.show(
      context,
      title: Strings.of(context)!.selectCategory,
      categories: cubit.state.categories.where((c) => !c.archived).toList(),
      selectedId: cubit.state.categoryId,
    );
    if (category?.id != null) cubit.categoryChanged(category!.id!);
  }
}
