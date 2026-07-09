import 'package:flutter/cupertino.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jaga_saku/core/usecase/usecase.dart';

/// Shared mocktail declarations + fallback registration for the test suite.
///
/// Trimmed to the M0 surface (no feature modules yet). Add mocks here as
/// features land; keep one thin `class MockX extends Mock implements X {}`
/// per mocked type and register a fallback for any custom type passed to
/// `any()` / `captureAny()`.

class MockBuildContext extends Mock implements BuildContext {}

/// Registers fallback sentinels for custom (non-nullable) types used with
/// `any()` / `captureAny()` matchers. Idempotent — safe to call repeatedly.
void registerFallbackValues() {
  registerFallbackValue(NoParams());
}
