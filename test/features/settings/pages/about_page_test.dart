import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/settings/pages/about_page.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../helpers/pump_app.dart';

/// [AboutPage] smoke test: the app name, tagline, the real runtime version
/// (mocked via `package_info_plus`) and a Licenses row all render.
void main() {
  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'Jaga Saku',
      packageName: 'com.example.jaga_saku',
      version: '1.2.3',
      buildNumber: '7',
      buildSignature: '',
    );
  });

  testWidgets('renders app name, tagline, version and a Licenses row', (
    tester,
  ) async {
    await pumpApp(tester, const AboutPage(), scaffold: false);
    await tester.pumpAndSettle();

    expect(find.text('Jaga Saku'), findsOneWidget);
    expect(find.text('Track spending, understand habits.'), findsOneWidget);
    expect(find.text('Version 1.2.3 (7)'), findsOneWidget);
    expect(find.text('Licenses'), findsOneWidget);
  });
}
