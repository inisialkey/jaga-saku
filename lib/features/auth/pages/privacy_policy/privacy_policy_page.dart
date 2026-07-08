import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) => Parent(
    appBar: MyAppBar(
      title: Strings.of(context)!.privacyPolicy,
      onBack: () => context.pop(),
    ),
    child: SingleChildScrollView(
      padding: EdgeInsets.all(Dimens.space24),
      child: Text(
        // TODO: Replace with actual privacy policy content
        Strings.of(context)!.privacyPolicy,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ),
  );
}
