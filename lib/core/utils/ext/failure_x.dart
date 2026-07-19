import 'package:flutter/widgets.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/localization/localization.dart';

extension FailureLocalization on Failure {
  /// User-safe, localized message for a [Failure].
  ///
  /// Every failure maps to an ARB string so users never see a raw English
  /// default. [ConflictFailure] keeps its own message when present (that is the
  /// intended business-facing text, e.g. "That name already exists"), falling
  /// back to a generic localized string.
  String localize(BuildContext context) {
    final s = Strings.of(context)!;
    // Exhaustive over the sealed Failure hierarchy — no wildcard, so a new
    // Failure subtype is a compile error until it gets a localized branch.
    return switch (this) {
      CacheFailure() => s.errorUnexpected,
      ConflictFailure(:final message) =>
        (message == null || message.isEmpty) ? s.errorConflict : message,
      BackupFailure(:final reason) => switch (reason) {
        BackupFailureReason.invalidFile => s.backupErrorInvalidFile,
        BackupFailureReason.unsupportedVersion =>
          s.backupErrorUnsupportedVersion,
        BackupFailureReason.corrupt => s.backupErrorCorrupt,
        BackupFailureReason.io => s.errorUnexpected,
      },
    };
  }
}
