// ARB parity checker — fails with exit 1 if intl_en.arb and intl_id.arb keys diverge.
//
// Usage:
//   dart run scripts/check_arb_parity.dart
//
// Invoked by:
//   - coder agent: after ARB changes, before `flutter gen-l10n`
//   - code-reviewer agent: auto-check before approval
//   - CI/CD: optional pre-build gate

import 'dart:convert';
import 'dart:io';

const String enPath = 'lib/core/localization/intl_en.arb';
const String idPath = 'lib/core/localization/intl_id.arb';

void main(List<String> args) {
  final enFile = File(enPath);
  final idFile = File(idPath);

  if (!enFile.existsSync()) {
    stderr.writeln('ERROR: $enPath not found');
    exit(2);
  }
  if (!idFile.existsSync()) {
    stderr.writeln('ERROR: $idPath not found');
    exit(2);
  }

  final Map<String, dynamic> en =
      jsonDecode(enFile.readAsStringSync()) as Map<String, dynamic>;
  final Map<String, dynamic> id =
      jsonDecode(idFile.readAsStringSync()) as Map<String, dynamic>;

  // Ignore ARB metadata keys (start with @ or @@)
  final enKeys = en.keys.where((k) => !k.startsWith('@')).toSet();
  final idKeys = id.keys.where((k) => !k.startsWith('@')).toSet();

  final missingInId = enKeys.difference(idKeys).toList()..sort();
  final missingInEn = idKeys.difference(enKeys).toList()..sort();

  if (missingInId.isEmpty && missingInEn.isEmpty) {
    stdout.writeln('OK: ARB parity verified (${enKeys.length} keys)');
    exit(0);
  }

  stderr.writeln('FAIL: ARB parity broken');
  if (missingInId.isNotEmpty) {
    stderr.writeln('\nKeys in $enPath but missing in $idPath:');
    for (final k in missingInId) {
      stderr.writeln('  - $k');
    }
  }
  if (missingInEn.isNotEmpty) {
    stderr.writeln('\nKeys in $idPath but missing in $enPath:');
    for (final k in missingInEn) {
      stderr.writeln('  - $k');
    }
  }
  stderr.writeln(
    '\nFix: add missing keys to both files before running `flutter gen-l10n`.',
  );
  exit(1);
}
