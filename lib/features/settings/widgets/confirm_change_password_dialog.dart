import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';

class ConfirmChangePasswordDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ConfirmChangePasswordDialog({required this.onConfirm, super.key});

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: EdgeInsets.symmetric(horizontal: Dimens.space24),
    child: Container(
      padding: EdgeInsets.all(Dimens.space24),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Palette.formDark
            : Palette.card,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Strings.of(context)!.changePassword,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Palette.iconDark
                  : Palette.icon,
              fontWeight: FontWeight.bold,
            ),
          ),
          SpacerV(value: Dimens.space12),
          Text(
            Strings.of(context)!.areYouSureYouWantToChangePassword,

            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: Palette.primary),
            textAlign: TextAlign.center,
          ),
          SpacerV(value: Dimens.space20),
          Row(
            children: [
              Expanded(
                child: Button(
                  title: Strings.of(context)!.cancel,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Palette.background
                      : Palette.lightRed,
                  titleColor: Theme.of(context).brightness == Brightness.dark
                      ? Palette.primary
                      : Palette.red,
                  onPressed: () => context.pop(),
                ),
              ),
              SpacerH(value: Dimens.space12),
              Expanded(
                child: Button(
                  title: Strings.of(context)!.update,
                  color: Theme.of(context).primaryColor,
                  titleColor: Colors.white,
                  onPressed: () {
                    context.pop();
                    onConfirm();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
