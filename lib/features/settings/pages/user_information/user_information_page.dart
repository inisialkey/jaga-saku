import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';

class UserInformationPage extends StatelessWidget {
  const UserInformationPage({super.key});

  @override
  Widget build(BuildContext context) => Parent(
    appBar: MyAppBar(
      title: Strings.of(context)!.userInfo,
      onBack: () => context.pop(),
    ),
    child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(Dimens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1
            Text(
              Strings.of(context)!.detailInfo,
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
                    color: Palette.backgroundDark.withValues(alpha: 0.1),
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
                    title: Strings.of(context)!.name,
                    onTap: () {
                      context.pushNamed(Routes.editName.name);
                    },
                  ),
                  MenuSection(
                    title: Strings.of(context)!.email,
                    onTap: () {
                      context.pushNamed(Routes.editEmail.name);
                    },
                  ),
                  MenuSection(
                    title: Strings.of(context)!.phoneNumber,
                    onTap: () {
                      context.pushNamed(Routes.editPhone.name);
                    },
                  ),
                  MenuSection(
                    title: Strings.of(context)!.location,
                    onTap: () {
                      context.pushNamed(Routes.editLocation.name);
                    },
                    showDivider: false,
                  ),
                ],
              ),
            ),
            SpacerV(value: Dimens.space5),
            // section 2
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimens.space8),
              child: Text(
                Strings.of(context)!.dataBody,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: Palette.subText),
              ),
            ),
            Container(
              padding: EdgeInsets.all(Dimens.space12),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Palette.backgroundDark.withValues(alpha: 0.1),
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
                    title: Strings.of(context)!.age,
                    onTap: () {
                      context.pushNamed(Routes.editAge.name);
                    },
                  ),
                  MenuSection(
                    title: Strings.of(context)!.gender,
                    onTap: () {
                      context.pushNamed(Routes.editGender.name);
                    },
                  ),
                  MenuSection(
                    title: Strings.of(context)!.height,
                    onTap: () {
                      context.pushNamed(Routes.editHeight.name);
                    },
                  ),
                  MenuSection(
                    title: Strings.of(context)!.weight,
                    onTap: () {
                      context.pushNamed(Routes.editWeight.name);
                    },
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
