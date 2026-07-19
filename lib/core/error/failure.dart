import 'package:equatable/equatable.dart';

/// Base type for every domain-facing failure.
///
/// `sealed` so `switch (failure)` is exhaustive — adding a new subtype forces
/// a localized branch in [FailureLocalization.localize] at compile time.
/// Extends [Equatable] so subclasses get value equality from [props] instead
/// of hand-rolled `==` / `hashCode`.
sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => const [];
}

class CacheFailure extends Failure {
  const CacheFailure();
}

/// A write conflicts with existing state — e.g. a uniqueness guard rejects a
/// duplicate.
class ConflictFailure extends Failure {
  final String? message;

  const ConflictFailure([this.message]);

  @override
  List<Object?> get props => [message];
}

/// Why a backup export/restore failed (V3-M1). Drives the localized message in
/// `FailureLocalization.localize` — each reason maps to a friendly ARB string so
/// a corrupt/incompatible file never surfaces a raw exception (rule 17).
enum BackupFailureReason {
  /// Picked file isn't parseable JSON or lacks the Jaga Saku envelope.
  invalidFile,

  /// `schemaVersion` is newer than this app can read (can't down-migrate).
  unsupportedVersion,

  /// Envelope is valid but its data fails integrity (duplicate ids / broken FK).
  corrupt,

  /// File I/O or an unexpected DB error while reading/writing/restoring.
  io,
}

/// A backup export/restore failure (V3-M1). Lives here because [Failure] is
/// `sealed` — every subtype must share this library so `switch (failure)` stays
/// exhaustive.
class BackupFailure extends Failure {
  final BackupFailureReason reason;

  const BackupFailure(this.reason);

  @override
  List<Object?> get props => [reason];
}
