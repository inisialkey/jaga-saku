import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/shell/widgets/placeholder_view.dart';

/// M0 placeholder for the Calendar tab (grid + daily summary land later).
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) => PlaceholderView(
    title: Strings.of(context)?.calendar ?? 'Calendar',
    icon: Icons.calendar_today_rounded,
  );
}
