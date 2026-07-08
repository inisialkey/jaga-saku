import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

class Empty extends StatelessWidget {
  final String? errorMessage;

  const Empty({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(Images.icLogo, width: context.widthInPercent(45)),
      Text(errorMessage ?? Strings.of(context)!.errorNoData),
    ],
  );
}
