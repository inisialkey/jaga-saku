import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/home/home.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: EdgeInsets.symmetric(horizontal: Dimens.space24),
    child: BlocListener<LogoutCubit, LogoutState>(
      listener: (ctx, state) => switch (state) {
        LogoutStateLoading() => ctx.show(),
        LogoutStateFailure(:final failure) => (() {
          ctx.dismiss();
          failure.localize(context).toToastError(context);
        })(),
        LogoutStateSuccess() => (() {
          ctx.dismiss();
          ctx.pop();
          context.goNamed(Routes.root.name);
        })(),
      },
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
              Strings.of(context)!.logOutTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Palette.red,
                fontWeight: FontWeight.bold,
              ),
            ),

            SpacerV(value: Dimens.space12),

            /// Description
            Text(
              Strings.of(context)!.logOutConfirmation,
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
                    color: Palette.lightRed,
                    titleColor: Palette.red,
                    onPressed: () => context.pop(),
                  ),
                ),

                SpacerH(value: Dimens.space12),

                /// Yes
                Expanded(
                  child: Button(
                    title: Strings.of(context)!.yes,
                    color: Theme.of(context).primaryColor,
                    titleColor: Colors.white,
                    onPressed: () => context.read<LogoutCubit>().postLogout(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
