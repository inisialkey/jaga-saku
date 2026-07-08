// Reusable white-label / rename tool for this Flutter Clean Architecture starter.
//
// Renames, in one pass:
//   1. The Dart package name      -> pubspec.yaml `name:` + every
//                                    `package:<old>/` import across lib/ + test/.
//   2. The bundle id / appId      -> Android gradle (applicationId + namespace),
//                                    iOS pbxproj, xcschemes, fastlane Fastfile /
//                                    Matchfile, ExportOptions plists. The
//                                    per-flavor `.dev` / `.stg` suffixes are
//                                    preserved automatically.
//   3. The app display name       -> gradle resValues, iOS APP_DISPLAY_NAME /
//                                    PRODUCT_NAME / *.app references, Info.plist
//                                    CFBundleName, Dart `Constants.appName`.
//   4. The Android MainActivity   -> moves the Kotlin source into the package
//                                    directory matching the new bundle id and
//                                    rewrites its `package` declaration.
//
// Usage:
//   dart run tool/rename_app.dart \
//       --package my_new_app \
//       --bundle  com.acme.myapp \
//       --name    "My App"
//
//   Optional flags:
//     --old-package <pkg>     Override auto-detected current Dart package name.
//     --old-bundle  <bundle>  Override auto-detected current base bundle id.
//     --dry-run               Print what would change without writing.
//
// The script is idempotent-ish: re-running with the same values is a no-op,
// and the bundle/name replacements always match the longest (flavor-suffixed)
// variant first so suffixes never get doubled.
//
// This is build tooling, so it prints to stdout (the repo's no-print lint rule
// targets app code, not tooling).

import 'dart:io';

const String _flavorDev = '.dev';
const String _flavorStg = '.stg';

/// A single literal substitution (`from` -> `to`).
class _Sub {
  const _Sub(this.from, this.to);

  final String from;
  final String to;
}

void main(List<String> args) {
  final Map<String, String> opts = _parseArgs(args);

  final String? newPackage = opts['package'];
  final String? newBundle = opts['bundle'];
  final String? newName = opts['name'];
  final bool dryRun = opts.containsKey('dry-run');

  if (newPackage == null || newBundle == null || newName == null) {
    _usageAndExit(
      'Missing required flag(s). Need --package, --bundle, --name.',
    );
  }

  _validatePackage(newPackage);
  _validateBundle(newBundle);

  final Directory root = _findProjectRoot();
  stdout.writeln('Project root: ${root.path}');

  final String oldPackage = opts['old-package'] ?? _detectDartPackage(root);
  final String oldBundle = opts['old-bundle'] ?? _detectBundleId(root);
  final String oldName = _detectAppName(root) ?? 'App';

  stdout
    ..writeln('Dart package : $oldPackage  ->  $newPackage')
    ..writeln('Bundle id    : $oldBundle  ->  $newBundle')
    ..writeln('Display name : $oldName  ->  $newName')
    ..writeln(dryRun ? '(dry run - no files written)\n' : '');

  final _Renamer renamer = _Renamer(
    root: root,
    oldPackage: oldPackage,
    newPackage: newPackage,
    oldBundle: oldBundle,
    newBundle: newBundle,
    oldName: oldName,
    newName: newName,
    dryRun: dryRun,
  );

  renamer
    ..renameDartPackage()
    ..renameBundleAndName()
    ..moveAndroidMainActivity();

  renamer.printSummary();

  stdout
    ..writeln()
    ..writeln('Done. Next steps you MUST do manually:')
    ..writeln('  1. Replace branding assets (they still carry the old logo):')
    ..writeln('       assets/images/ic_launcher*.png, ic_logo*.png,')
    ..writeln('       assets/images/background*.jpeg, banner1.png')
    ..writeln('     then regenerate:')
    ..writeln(
      '       dart run flutter_launcher_icons -f flutter_launcher_icons-prd.yaml',
    )
    ..writeln(
      '       dart run flutter_native_splash:create --path flutter_native_splash-prd.yaml',
    )
    ..writeln('  2. Re-link Firebase for the new bundle id / appId:')
    ..writeln('       flutterfire configure')
    ..writeln('     (replaces android/app/src/*/google-services.json and')
    ..writeln('      ios/config/*/GoogleService-Info.plist).')
    ..writeln(
      '  3. Update the iOS signing teamID in ios/fastlane/ExportOptions-*.plist',
    )
    ..writeln(
      '     and provisioning profiles to your own Apple Developer account.',
    )
    ..writeln(
      '  4. Run: fvm flutter pub get && fvm flutter analyze && fvm flutter test',
    );
}

// ---------------------------------------------------------------------------
// Renamer
// ---------------------------------------------------------------------------

class _Renamer {
  _Renamer({
    required this.root,
    required this.oldPackage,
    required this.newPackage,
    required this.oldBundle,
    required this.newBundle,
    required this.oldName,
    required this.newName,
    required this.dryRun,
  });

  final Directory root;
  final String oldPackage;
  final String newPackage;
  final String oldBundle;
  final String newBundle;
  final String oldName;
  final String newName;
  final bool dryRun;

  int _filesChanged = 0;
  final List<String> _notes = <String>[];

  void renameDartPackage() {
    // pubspec name + all package: imports across lib/ + test/ (and tool/).
    final List<File> dartFiles = <File>[
      ..._dartFilesIn('lib'),
      ..._dartFilesIn('test'),
    ];

    for (final File f in dartFiles) {
      _replaceInFile(f, <_Sub>[
        _Sub('package:$oldPackage/', 'package:$newPackage/'),
      ]);
    }

    final File pubspec = File('${root.path}/pubspec.yaml');
    _replaceInFile(pubspec, <_Sub>[
      _Sub('name: $oldPackage', 'name: $newPackage'),
    ]);
  }

  void renameBundleAndName() {
    // Bundle id substitutions: longest (flavor-suffixed) first so the base
    // replacement never corrupts an already-replaced suffixed id.
    final List<_Sub> bundleSubs = <_Sub>[
      _Sub('$oldBundle$_flavorDev', '$newBundle$_flavorDev'),
      _Sub('$oldBundle$_flavorStg', '$newBundle$_flavorStg'),
      _Sub(oldBundle, newBundle),
    ];

    // Display-name substitutions: longest first ("DEV"/"STG" before base).
    final List<_Sub> nameSubs = <_Sub>[
      _Sub('$oldName DEV', '$newName DEV'),
      _Sub('$oldName STG', '$newName STG'),
      _Sub(oldName, newName),
    ];

    final String compactOld = _compact(oldName);
    final String compactNew = _compact(newName);

    // Android gradle: bundle (applicationId + namespace) + display names.
    _editIfExists('android/app/build.gradle.kts', <_Sub>[
      ...bundleSubs,
      ...nameSubs,
    ]);

    // Android manifest: usually @string/app_name, but cover hardcoded labels.
    _editIfExists('android/app/src/main/AndroidManifest.xml', nameSubs);

    // Android fastlane.
    _editIfExists('android/fastlane/Fastfile', bundleSubs);

    // iOS project + schemes.
    _editIfExists('ios/Runner.xcodeproj/project.pbxproj', <_Sub>[
      ...bundleSubs,
      ...nameSubs,
    ]);
    for (final String scheme in <String>['dev', 'stg', 'prd']) {
      _editIfExists(
        'ios/Runner.xcodeproj/xcshareddata/xcschemes/$scheme.xcscheme',
        nameSubs,
      );
    }

    // iOS Info.plist: CFBundleName is compact (no spaces) by convention.
    _editIfExists('ios/Runner/Info.plist', <_Sub>[
      _Sub('<string>$compactOld</string>', '<string>$compactNew</string>'),
    ]);

    // iOS fastlane + export options.
    _editIfExists('ios/fastlane/Fastfile', bundleSubs);
    _editIfExists('ios/fastlane/Matchfile', bundleSubs);
    for (final String flavor in <String>['dev', 'stg', 'prd']) {
      _editIfExists('ios/fastlane/ExportOptions-$flavor.plist', bundleSubs);
    }

    // Dart Constants.appName.
    final File? constant = _firstExisting(<String>[
      'lib/core/utils/helper/constant.dart',
    ]);
    if (constant != null) {
      _replaceInFile(constant, <_Sub>[
        _Sub("appName = '$oldName'", "appName = '$newName'"),
      ]);
    }
  }

  void moveAndroidMainActivity() {
    final String kotlinRoot = '${root.path}/android/app/src/main/kotlin';
    final Directory kotlinDir = Directory(kotlinRoot);
    if (!kotlinDir.existsSync()) {
      _notes.add('Android kotlin dir not found; skipped MainActivity move.');
      return;
    }

    // Find the existing MainActivity.kt.
    final List<File> activities = kotlinDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((File f) => f.path.endsWith('MainActivity.kt'))
        .toList();

    if (activities.isEmpty) {
      _notes.add('MainActivity.kt not found; skipped move.');
      return;
    }

    final File current = activities.first;
    final String newPkgPath = newBundle.split('.').join('/');
    final String destPath = '$kotlinRoot/$newPkgPath/MainActivity.kt';

    if (current.path == destPath) {
      // Still rewrite package line in case it is stale.
      _replacePackageLine(current, newBundle);
      return;
    }

    if (dryRun) {
      stdout.writeln(
        '  [dry] move ${_rel(current.path)} -> '
        '${_rel(destPath)} (package $newBundle)',
      );
      _filesChanged++;
      return;
    }

    final String content = current.readAsStringSync().replaceFirst(
      RegExp(r'^package\s+[\w.]+', multiLine: true),
      'package $newBundle',
    );
    final File dest = File(destPath);
    dest.parent.createSync(recursive: true);
    dest.writeAsStringSync(content);

    if (current.path != destPath) {
      current.deleteSync();
      _pruneEmptyDirs(current.parent, stopAt: kotlinDir);
    }

    stdout.writeln('  moved ${_rel(current.path)} -> ${_rel(destPath)}');
    _filesChanged++;
  }

  void printSummary() {
    stdout.writeln(
      '\n$_filesChanged file(s) ${dryRun ? "would change" : "changed"}.',
    );
    for (final String note in _notes) {
      stdout.writeln('  note: $note');
    }
  }

  // -- helpers ---------------------------------------------------------------

  void _replacePackageLine(File f, String pkg) {
    _replaceWith(
      f,
      (String c) => c.replaceFirst(
        RegExp(r'^package\s+[\w.]+', multiLine: true),
        'package $pkg',
      ),
    );
  }

  void _editIfExists(String relPath, List<_Sub> subs) {
    final File f = File('${root.path}/$relPath');
    if (f.existsSync()) {
      _replaceInFile(f, subs);
    }
  }

  void _replaceInFile(File f, List<_Sub> subs) {
    _replaceWith(f, (String c) {
      String out = c;
      for (final _Sub s in subs) {
        out = out.replaceAll(s.from, s.to);
      }
      return out;
    });
  }

  void _replaceWith(File f, String Function(String) transform) {
    final String before = f.readAsStringSync();
    final String after = transform(before);
    if (before == after) {
      return;
    }
    if (!dryRun) {
      f.writeAsStringSync(after);
    }
    stdout.writeln('  ${dryRun ? "[dry] " : ""}edited ${_rel(f.path)}');
    _filesChanged++;
  }

  List<File> _dartFilesIn(String relDir) {
    final Directory d = Directory('${root.path}/$relDir');
    if (!d.existsSync()) {
      return <File>[];
    }
    return d
        .listSync(recursive: true)
        .whereType<File>()
        .where((File f) => f.path.endsWith('.dart'))
        .toList();
  }

  File? _firstExisting(List<String> relPaths) {
    for (final String p in relPaths) {
      final File f = File('${root.path}/$p');
      if (f.existsSync()) {
        return f;
      }
    }
    return null;
  }

  void _pruneEmptyDirs(Directory dir, {required Directory stopAt}) {
    Directory current = dir;
    while (current.path != stopAt.path &&
        current.path.startsWith(stopAt.path) &&
        current.existsSync() &&
        current.listSync().isEmpty) {
      final Directory parent = current.parent;
      current.deleteSync();
      current = parent;
    }
  }

  String _rel(String absPath) => absPath.startsWith(root.path)
      ? absPath.substring(root.path.length + 1)
      : absPath;
}

// ---------------------------------------------------------------------------
// Detection + validation
// ---------------------------------------------------------------------------

String _detectDartPackage(Directory root) {
  final File pubspec = File('${root.path}/pubspec.yaml');
  final RegExp re = RegExp(r'^name:\s*(\S+)', multiLine: true);
  final Match? m = re.firstMatch(pubspec.readAsStringSync());
  if (m == null) {
    _usageAndExit('Could not detect Dart package name from pubspec.yaml.');
  }
  return m.group(1)!;
}

String _detectBundleId(Directory root) {
  final File gradle = File('${root.path}/android/app/build.gradle.kts');
  if (gradle.existsSync()) {
    final RegExp re = RegExp(r'applicationId\s*=\s*"([^"]+)"');
    final Match? m = re.firstMatch(gradle.readAsStringSync());
    if (m != null) {
      return m.group(1)!;
    }
  }
  _usageAndExit('Could not detect base bundle id from build.gradle.kts.');
}

String? _detectAppName(Directory root) {
  final File constant = File(
    '${root.path}/lib/core/utils/helper/constant.dart',
  );
  if (constant.existsSync()) {
    final RegExp re = RegExp(r"appName\s*=\s*'([^']+)'");
    final Match? m = re.firstMatch(constant.readAsStringSync());
    if (m != null) {
      return m.group(1);
    }
  }
  // Fall back to the prd resValue in gradle.
  final File gradle = File('${root.path}/android/app/build.gradle.kts');
  if (gradle.existsSync()) {
    final RegExp re = RegExp(
      r'resValue\("string", "app_name", "([^"]+?)( DEV| STG)?"\)',
    );
    for (final Match m in re.allMatches(gradle.readAsStringSync())) {
      if (m.group(2) == null) {
        return m.group(1);
      }
    }
  }
  return null;
}

void _validatePackage(String pkg) {
  if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(pkg)) {
    _usageAndExit(
      'Invalid --package "$pkg". Use lower_snake_case (a-z, 0-9, _), '
      'starting with a letter.',
    );
  }
}

void _validateBundle(String bundle) {
  // Reverse-domain, no underscores. At least two segments.
  if (!RegExp(
    r'^[a-zA-Z][a-zA-Z0-9]*(\.[a-zA-Z][a-zA-Z0-9]*)+$',
  ).hasMatch(bundle)) {
    _usageAndExit(
      'Invalid --bundle "$bundle". Use reverse-domain notation, e.g. '
      'com.acme.myapp (letters/digits only, NO underscores, >= 2 segments).',
    );
  }
}

// ---------------------------------------------------------------------------
// Arg parsing + misc
// ---------------------------------------------------------------------------

Map<String, String> _parseArgs(List<String> args) {
  final Map<String, String> out = <String, String>{};
  for (int i = 0; i < args.length; i++) {
    final String a = args[i];
    if (!a.startsWith('--')) {
      continue;
    }
    final String key = a.substring(2);
    if (key == 'dry-run') {
      out[key] = 'true';
      continue;
    }
    if (i + 1 < args.length && !args[i + 1].startsWith('--')) {
      out[key] = args[++i];
    } else {
      out[key] = '';
    }
  }
  return out;
}

Directory _findProjectRoot() {
  Directory dir = Directory.current;
  while (true) {
    if (File('${dir.path}/pubspec.yaml').existsSync()) {
      return dir;
    }
    final Directory parent = dir.parent;
    if (parent.path == dir.path) {
      _usageAndExit('Could not find pubspec.yaml in any parent directory.');
    }
    dir = parent;
  }
}

String _compact(String name) => name.replaceAll(' ', '').toLowerCase();

Never _usageAndExit(String message) {
  stderr
    ..writeln('Error: $message')
    ..writeln()
    ..writeln('Usage:')
    ..writeln('  dart run tool/rename_app.dart \\')
    ..writeln('      --package my_new_app \\')
    ..writeln('      --bundle  com.acme.myapp \\')
    ..writeln('      --name    "My App"')
    ..writeln()
    ..writeln('Optional: --old-package, --old-bundle, --dry-run');
  exit(64); // EX_USAGE
}
