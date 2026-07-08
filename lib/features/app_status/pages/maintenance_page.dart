import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';

/// Full-screen gate shown when the backend returns `MAINTENANCE_MODE`. Routed
/// to by [DioInterceptor] on that error code. Unlike force-update it offers a
/// retry (back to root) so the user can re-attempt once maintenance is over.
class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return PopScope(
      canPop: false,
      child: Parent(
        child: Padding(
          padding: EdgeInsets.all(Dimens.space24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.engineering_outlined,
                  size: 72,
                  color: Theme.of(context).primaryColor,
                ),
                SpacerV(value: Dimens.space16),
                Text(
                  s.maintenanceTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SpacerV(value: Dimens.space8),
                Text(
                  s.errorMaintenance,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SpacerV(value: Dimens.space24),
                Button(
                  width: double.maxFinite,
                  title: s.retry,
                  onPressed: () => context.go(Routes.root.path),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
