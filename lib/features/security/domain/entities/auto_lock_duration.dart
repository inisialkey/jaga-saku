/// How long the app may sit backgrounded before the lock re-arms on resume
/// (V3-M4). Labels are localized in the ARB (never the enum `.name`); only the
/// [duration] mapping lives here. `immediately` ⇒ any background re-locks.
enum AutoLockDuration {
  immediately,
  oneMinute,
  fiveMinutes,
  fifteenMinutes;

  /// Elapsed-background threshold at/after which a resume re-locks the app.
  Duration get duration => switch (this) {
    AutoLockDuration.immediately => Duration.zero,
    AutoLockDuration.oneMinute => const Duration(minutes: 1),
    AutoLockDuration.fiveMinutes => const Duration(minutes: 5),
    AutoLockDuration.fifteenMinutes => const Duration(minutes: 15),
  };

  /// Maps a persisted `.name` back to the enum, defaulting to [immediately] for
  /// an unknown / legacy value (never throws).
  static AutoLockDuration fromName(String? name) =>
      AutoLockDuration.values.firstWhere(
        (d) => d.name == name,
        orElse: () => AutoLockDuration.immediately,
      );
}
