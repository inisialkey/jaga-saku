import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/users/users.dart';

/// User edit form (`/users/:id/edit`). Prefilled with the passed-in [user]
/// (via `extra`); Save submits a partial update and pops on success.
class UserEditPage extends StatefulWidget {
  const UserEditPage({required this.id, this.user, super.key});

  final String id;
  final User? user;

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _avatarController;

  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _phoneController = TextEditingController(text: widget.user?.phone ?? '');
    _avatarController = TextEditingController(
      text: widget.user?.avatarUrl ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  void _onSave() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final avatar = _avatarController.text.trim();
    context.read<UserEditCubit>().submit(
      widget.id,
      name: name.isEmpty ? null : name,
      phone: phone.isEmpty ? null : phone,
      avatarUrl: avatar.isEmpty ? null : avatar,
    );
  }

  Future<void> _pickAvatar() async {
    if (_isUploading) return;
    setState(() => _isUploading = true);
    final result = await context.read<UserEditCubit>().pickAndUploadAvatar();
    if (!mounted) return;
    setState(() => _isUploading = false);
    result.fold((failure) => failure.localize(context).toToastError(context), (
      url,
    ) {
      if (url == null) return; // user cancelled the picker
      _avatarController.text = url;
      Strings.of(context)!.photoUploaded.toToastSuccess(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return BlocConsumer<UserEditCubit, UserEditState>(
      listener: (context, state) {
        if (state is UserEditStateSuccess) {
          s.updatedSuccess.toToastSuccess(context);
          context.pop();
        } else if (state is UserEditStateFailure) {
          state.failure.localize(context).toToastError(context);
        }
      },
      builder: (context, state) {
        final isSubmitting = state is UserEditStateSubmitting;
        return Parent(
          appBar: MyAppBar(title: s.editUser, onBack: () => context.pop()),
          bottomNavigation: Padding(
            padding: EdgeInsets.all(Dimens.space24),
            child: Button(
              key: const Key('save_button'),
              width: double.maxFinite,
              title: s.save,
              onPressed: (isSubmitting || _isUploading) ? null : _onSave,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Dimens.space24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.name, style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: Dimens.space8),
                  TextF(
                    key: const Key('name_field'),
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    hint: s.name,
                  ),
                  SizedBox(height: Dimens.space16),
                  Text(
                    s.phoneNumber,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: Dimens.space8),
                  TextF(
                    key: const Key('phone_field'),
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    hint: s.phoneNumber,
                  ),
                  SizedBox(height: Dimens.space16),
                  Text(
                    s.avatarUrl,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: Dimens.space8),
                  TextF(
                    key: const Key('avatar_field'),
                    controller: _avatarController,
                    keyboardType: TextInputType.url,
                    hint: s.avatarUrl,
                    suffixIcon: _isUploading
                        ? const Padding(
                            padding: EdgeInsets.all(14),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            key: const Key('upload_avatar_button'),
                            icon: const Icon(Icons.upload_outlined),
                            onPressed: _pickAvatar,
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
