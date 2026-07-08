import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/home/home.dart';

class MainPage extends StatelessWidget {
  const MainPage({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MainCubit>();
    final location = GoRouterState.of(context).matchedLocation;
    // Sync after the frame: emitting during build() throws in debug.
    // syncIndexFromPath is a no-op when the index already matches.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.syncIndexFromPath(location);
    });

    return PopScope(
      onPopInvokedWithResult: (_, _) {
        if (!cubit.onBackPressed()) {
          context.goNamed(MainCubit.routes[0].name);
        }
      },
      child: Parent(
        extendBody: true,
        bottomNavigation: BlocBuilder<MainCubit, MainState>(
          builder: (_, state) => FloatingBottomNavBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.updateIndex(index);
              context.goNamed(MainCubit.routes[index].name);
            },
          ),
        ),
        child: child,
      ),
    );
  }
}
