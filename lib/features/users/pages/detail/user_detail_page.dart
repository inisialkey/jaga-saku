import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/users/users.dart';

/// User detail (`/users/:id`). Shows the user fields with Edit and Delete
/// actions. Delete confirms via a dialog, then pops back to the list.
class UserDetailPage extends StatefulWidget {
  const UserDetailPage({required this.id, super.key});

  final String id;

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserDetailCubit>().load(widget.id);
  }

  Future<void> _openEdit(User user) async {
    final args = UserRouteArgs(id: user.id, user: user);
    await context.pushNamed(
      Routes.userEdit.name,
      pathParameters: args.toPathParameters(),
      extra: args.user,
    );
    if (!mounted) return;
    await context.read<UserDetailCubit>().load(widget.id);
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final s = Strings.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(s.deleteConfirmTitle),
        content: Text(s.deleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(s.yesDelete),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    await context.read<UserEditCubit>().delete(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return BlocListener<UserEditCubit, UserEditState>(
      listener: (context, state) {
        if (state is UserEditStateDeleted) {
          s.deletedSuccess.toToastSuccess(context);
          context.pop();
        } else if (state is UserEditStateFailure) {
          state.failure.localize(context).toToastError(context);
        }
      },
      child: Parent(
        appBar: MyAppBar(title: s.userDetailTitle, onBack: () => context.pop()),
        child: SafeArea(
          child: BlocBuilder<UserDetailCubit, UserDetailState>(
            builder: (context, state) => switch (state) {
              UserDetailStateLoading() => const Center(child: Loading()),
              UserDetailStateFailure(:final failure) => Center(
                child: Empty(errorMessage: failure.localize(context)),
              ),
              UserDetailStateLoaded(:final user) => _DetailBody(
                user: user,
                onEdit: () => _openEdit(user),
                onDelete: () => _confirmDelete(context),
              ),
            },
          ),
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  final User user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return SingleChildScrollView(
      padding: EdgeInsets.all(Dimens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: SizedBox(
              width: Dimens.space120,
              height: Dimens.space120,
              child: (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                  ? CircleImage(url: user.avatarUrl!, size: Dimens.space120)
                  : const CircleAvatar(child: Icon(Icons.person, size: 48)),
            ),
          ),
          SizedBox(height: Dimens.space24),
          _Field(label: s.name, value: user.name),
          _Field(label: s.email, value: user.email),
          _Field(label: s.phoneNumber, value: user.phone ?? '-'),
          _Field(label: s.role, value: user.role),
          SizedBox(height: Dimens.space24),
          Button(
            key: const Key('edit_button'),
            width: double.maxFinite,
            title: s.edit,
            onPressed: onEdit,
          ),
          SizedBox(height: Dimens.space12),
          Button(
            key: const Key('delete_button'),
            width: double.maxFinite,
            color: context.colors.red,
            title: s.delete,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: Dimens.space8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        SizedBox(height: Dimens.space4),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ],
    ),
  );
}
