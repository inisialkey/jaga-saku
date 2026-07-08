import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) => Parent(
    appBar: MyAppBar(
      title: Strings.of(context)!.termsOfService,
      onBack: () => context.pop(),
    ),
    child: SingleChildScrollView(
      padding: EdgeInsets.all(Dimens.space24),
      child: Text(
        // TODO: Replace with actual terms of service content
        Strings.of(context)!.termsOfService,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ),
  );
}
