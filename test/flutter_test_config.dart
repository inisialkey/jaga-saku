import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/mocks.dart';

/// Runs once per test isolate before any test's `main()`.
/// - Registers mocktail fallback values for every custom type used with
///   `any()` / `captureAny()` matchers ([registerFallbackValues]).
/// - Installs a tolerant golden comparator (see [_TolerantGoldenComparator]).
/// - Configures Alchemist to only generate/compare **CI** goldens (deterministic
///   rendering), not platform-specific ones.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  registerFallbackValues();

  // Goldens are generated on a dev machine (e.g. macOS) but compared on the
  // Linux CI runner; sub-pixel anti-aliasing differs slightly between Skia
  // backends (~0.2% noise). Allow a small pixel-diff threshold so that noise
  // doesn't fail CI, while real visual changes (well above the threshold) still
  // do. Preserves the default comparator's basedir for golden path resolution.
  final comparator = goldenFileComparator;
  if (comparator is LocalFileComparator) {
    goldenFileComparator = _TolerantGoldenComparator(
      comparator.basedir.resolve('flutter_test_config.dart'),
      threshold: 0.005, // 0.5%
    );
  }

  return AlchemistConfig.runWithConfig(
    config: const AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(enabled: false),
    ),
    run: testMain,
  );
}

/// A [LocalFileComparator] that passes when the pixel diff is within [threshold]
/// (a fraction, e.g. 0.005 = 0.5%). Cross-platform AA noise stays green; real
/// regressions still fail and still emit the usual failure/diff images.
class _TolerantGoldenComparator extends LocalFileComparator {
  _TolerantGoldenComparator(super.testFile, {required this.threshold});

  final double threshold;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    if (result.passed || result.diffPercent <= threshold) return true;
    final error = await generateFailureOutput(result, golden, basedir);
    throw FlutterError(error);
  }
}
