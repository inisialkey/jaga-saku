import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/settings/pages/user_information/cubit/cubit.dart';

class EditNamePage extends StatefulWidget {
  const EditNamePage({super.key});

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final _conName = TextEditingController();
  final _fnName = FocusNode();

  bool _isNameValid = false;

  void _onSave() {
    if (!_isNameValid) return;
    context.read<EditNameCubit>().submit(_conName.text.trim());
  }

  @override
  void dispose() {
    _conName.dispose();
    _fnName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<EditNameCubit, EditNameState>(
        listener: (context, state) {
          switch (state) {
            case EditNameStateLoaded(:final name):
              _conName.text = name;
              setState(() => _isNameValid = name.trim().isNotEmpty);
            case EditNameStateSuccess():
              Strings.of(context)!.profileUpdated.toToastSuccess(context);
              context.pop();
            case EditNameStateFailure(:final failure):
              failure.localize(context).toToastError(context);
            case EditNameStateLoading():
            case EditNameStateSubmitting():
              break;
          }
        },
        builder: (context, state) {
          final isSubmitting = state is EditNameStateSubmitting;
          return Parent(
            appBar: MyAppBar(
              title: Strings.of(context)!.editName,
              onBack: () => context.pop(),
            ),
            bottomNavigation: Padding(
              padding: EdgeInsets.all(Dimens.space24),
              child: Button(
                width: double.maxFinite,
                title: Strings.of(context)!.save,
                onPressed: (_isNameValid && !isSubmitting) ? _onSave : null,
              ),
            ),
            child: state is EditNameStateLoading
                ? const Loading()
                : SingleChildScrollView(
                    padding: EdgeInsets.all(Dimens.space24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Strings.of(context)!.pleaseEnterName,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: Dimens.space8),
                        TextF(
                          autoFillHints: const [AutofillHints.name],
                          key: const Key('name'),
                          focusNode: _fnName,
                          textInputAction: TextInputAction.done,
                          controller: _conName,
                          keyboardType: TextInputType.name,
                          hint: Strings.of(context)!.name,
                          isValid: _isNameValid,
                          validatorListener: (String value) {
                            setState(() {
                              _isNameValid = value.trim().isNotEmpty;
                            });
                          },
                          errorMessage: Strings.of(context)!.errorEmptyField,
                        ),
                      ],
                    ),
                  ),
          );
        },
      );
}
