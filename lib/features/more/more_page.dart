import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/shell/widgets/placeholder_view.dart';

/// M0 placeholder for the More tab (grouped menu lands in M6).
class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) => PlaceholderView(
    title: Strings.of(context)?.more ?? 'More',
    icon: Icons.more_horiz_rounded,
  );
}
