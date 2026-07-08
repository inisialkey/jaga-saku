import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

class SpacerV extends StatelessWidget {
  const SpacerV({super.key, this.value});

  final double? value;

  @override
  Widget build(BuildContext context) =>
      Container(height: value ?? Dimens.space8);
}
