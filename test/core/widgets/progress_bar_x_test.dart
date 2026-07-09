import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

import '../../helpers/pump_app.dart';

void main() {
  Future<double?> renderedValue(WidgetTester tester, double value) async {
    await pumpApp(tester, ProgressBarX(value: value));
    return tester
        .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
        .value;
  }

  group('ProgressBarX', () {
    testWidgets('passes a mid-range value through unchanged', (tester) async {
      expect(await renderedValue(tester, 0.4), 0.4);
    });

    testWidgets('clamps values above 1 to 1', (tester) async {
      expect(await renderedValue(tester, 1.5), 1.0);
    });

    testWidgets('clamps negative values to 0', (tester) async {
      expect(await renderedValue(tester, -0.5), 0.0);
    });
  });
}
