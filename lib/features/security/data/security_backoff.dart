/// Timed-backoff policy for repeated wrong PINs (V3-M4).
///
/// The user's resolved decision: an increasing delay, **never a permanent
/// lockout**. The first 2 wrong PINs are free; then the cooldown escalates
/// 30s → 1m → 5m and caps at 15m. The cap means the delay never grows further,
/// so the user is never permanently locked out. The armed `locked-until`
/// timestamp is persisted in the `settings` kv (by the datasource) so a
/// force-kill cannot reset an active cooldown.
Duration backoffFor(int failedAttempts) => switch (failedAttempts) {
  <= 2 => Duration.zero,
  3 => const Duration(seconds: 30),
  4 => const Duration(minutes: 1),
  5 => const Duration(minutes: 5),
  _ => const Duration(minutes: 15),
};

/// Whether [now] is still inside an armed cooldown. A null [lockedUntilMs]
/// (none armed) is never in cooldown; the boundary `now == until` is NOT in
/// cooldown (the cooldown has just lifted).
bool isInCooldown(DateTime now, int? lockedUntilMs) =>
    lockedUntilMs != null && now.millisecondsSinceEpoch < lockedUntilMs;
