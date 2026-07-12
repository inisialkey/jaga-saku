import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/delete_recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/get_recurring_rules.dart';

part 'recurring_list_state.dart';
part 'recurring_list_cubit.freezed.dart';

/// Drives the recurring manage list: load + delete (which cascade-drops the
/// owned template, C4). Non-reorderable — rules are ordered by their `next_due`
/// cursor. Failures fold into [RecurringListError]; the widget localizes them
/// (rule 17). Every emit is guarded by [isClosed] (rule 5).
class RecurringListCubit extends Cubit<RecurringListState> {
  RecurringListCubit({
    required GetRecurringRules getRules,
    required DeleteRecurringRule deleteRule,
  }) : _getRules = getRules,
       _deleteRule = deleteRule,
       super(const RecurringListState.initial());

  final GetRecurringRules _getRules;
  final DeleteRecurringRule _deleteRule;

  Future<void> load() async {
    emit(const RecurringListState.loading());
    final result = await _getRules(NoParams());
    if (isClosed) return;
    emit(
      result.fold(
        RecurringListState.error,
        (rules) => RecurringListState.loaded(rules: rules),
      ),
    );
  }

  /// Deletes the rule (and its owned template via the FK cascade), then reloads.
  Future<void> delete(RecurringRule rule) async {
    final result = await _deleteRule(rule);
    if (isClosed) return;
    final failure = result.getLeft().toNullable();
    if (failure != null) {
      emit(RecurringListState.error(failure));
    } else {
      await load();
    }
  }
}
