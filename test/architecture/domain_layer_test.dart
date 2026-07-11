import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the Clean Architecture dependency rule at the import-graph level:
/// the domain layer must not depend on Flutter, the data layer, or the
/// kitchen-sink `core/core.dart` barrel (which transitively pulls in Flutter,
/// dio and go_router). If this fails, a domain file imported something it
/// shouldn't — import the specific `core/error`, `core/usecase`, `core/models`
/// barrel or the relevant `domain/...` file instead.
void main() {
  test('domain layer stays free of Flutter / data / kitchen-sink imports', () {
    final domainFiles = Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.contains('/domain/'))
        .where((f) => f.path.endsWith('.dart'))
        .where((f) => !f.path.endsWith('.freezed.dart'))
        .where((f) => !f.path.endsWith('.g.dart'));

    final umbrella = RegExp(
      r"import 'package:jaga_saku/features/([a-z_]+)/\1\.dart'",
    );
    final dataLayer = RegExp('package:jaga_saku/features/[a-z_]+/data/');

    final violations = <String>[];
    for (final file in domainFiles) {
      final src = file.readAsStringSync();
      if (src.contains("import 'package:flutter/")) {
        violations.add('${file.path}: imports package:flutter/*');
      }
      if (src.contains('package:jaga_saku/core/core.dart')) {
        violations.add('${file.path}: imports core/core.dart (kitchen sink)');
      }
      if (umbrella.hasMatch(src)) {
        violations.add('${file.path}: imports a feature umbrella barrel');
      }
      if (dataLayer.hasMatch(src)) {
        violations.add('${file.path}: imports the data layer');
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'Domain layer purity violated:\n${violations.join('\n')}',
    );
  });

  test('core layer never depends on a feature', () {
    final coreFiles = Directory('lib/core')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where((f) => !f.path.endsWith('.freezed.dart'))
        .where((f) => !f.path.endsWith('.g.dart'));

    final featureImport = RegExp("import 'package:jaga_saku/features/");

    final violations = <String>[
      for (final file in coreFiles)
        if (featureImport.hasMatch(file.readAsStringSync())) file.path,
    ];

    expect(
      violations,
      isEmpty,
      reason:
          'Core layer must not depend on a feature (inverts layering):\n'
          '${violations.join('\n')}',
    );
  });
}
