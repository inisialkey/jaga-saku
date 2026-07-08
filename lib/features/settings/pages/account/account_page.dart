import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/settings/settings.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) => Parent(
    appBar: MyAppBar(
      title: Strings.of(context)!.account,
      onBack: () => context.pop(),
    ),
    child: SingleChildScrollView(
      padding: EdgeInsets.all(Dimens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1
          Text(
            Strings.of(context)!.accountDetail,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: Palette.subText),
          ),
          SpacerV(value: Dimens.space8),
          Container(
            padding: EdgeInsets.all(Dimens.space12),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 2,
                ),
              ],
              color: Theme.of(context).brightness == Brightness.dark
                  ? Palette.primary.withValues(alpha: 0.1)
                  : Palette.background,
              borderRadius: BorderRadius.circular(Dimens.space16),
            ),
            child: Column(
              children: [
                MenuSection(
                  title: Strings.of(context)!.changePassword,
                  onTap: () {
                    context.pushNamed(Routes.changePassword.name);
                  },
                ),
                MenuSection(
                  title: Strings.of(context)!.deleteAccount,
                  titleColor: Palette.red,
                  trailingColor: Palette.red,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => DeleteAccountDialog(
                        onConfirm: () {
                          Strings.of(
                            context,
                          )!.featureNotAvailableYet.toToastError(context);
                        },
                      ),
                    );
                  },
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
