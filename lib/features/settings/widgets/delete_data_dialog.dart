import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';

class DeleteDataDialog extends StatelessWidget {
  const DeleteDataDialog({super.key});

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
          /// Title
          Text(
            Strings.of(context)!.deleteData,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Palette.red,
              fontWeight: FontWeight.bold,
            ),
          ),

          SpacerV(value: Dimens.space12),

          /// Description
          Text(
            Strings.of(context)!.deleteDataDesc,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Palette.card
                  : Palette.cardDark,
              fontWeight: FontWeight.w500,
            ),
          ),

          SpacerV(value: Dimens.space30),

          /// Buttons
          Row(
            children: [
              /// Cancel
              Expanded(
                child: Button(
                  title: Strings.of(context)!.cancel,
                  color: Palette.form,
                  titleColor: Palette.icon,
                  onPressed: () => context.pop(),
                ),
              ),

              SpacerH(value: Dimens.space12),

              /// Yes
              Expanded(
                child: Button(
                  title: Strings.of(context)!.yesDelete,
                  color: Palette.red,
                  titleColor: Colors.white,
                  onPressed: () => context.pop(),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
