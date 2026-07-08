import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jaga_saku/core/core.dart';

/// Full-screen, non-dismissable gate shown when the backend returns
/// `FORCE_UPDATE_REQUIRED`. Routed to by [DioInterceptor] on that error code.
class ForceUpdatePage extends StatelessWidget {
  const ForceUpdatePage({super.key});

  Future<void> _openStore() async {
    final uri = Uri.parse(
      Platform.isIOS
          ? AppStoreConfig.iosAppStoreUrl
          : AppStoreConfig.androidPlayStoreUrl,
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception catch (error, stackTrace) {
      log.e('Failed to open store', error: error, stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    // Force-update is unescapable — block the system back gesture/button.
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
                  Icons.system_update,
                  size: 72,
                  color: Theme.of(context).primaryColor,
                ),
                SpacerV(value: Dimens.space16),
                Text(
                  s.forceUpdateTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SpacerV(value: Dimens.space8),
                Text(
                  s.errorForceUpdate,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SpacerV(value: Dimens.space24),
                Button(
                  width: double.maxFinite,
                  title: s.updateNow,
                  onPressed: _openStore,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
