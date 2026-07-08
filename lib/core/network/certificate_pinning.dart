import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';

/// Master switch for TLS certificate pinning. OFF by default.
///
/// Pinning only matters for release builds talking to real, controlled hosts.
/// Enable it ONLY when [kCertificatePins] is populated with the pin(s) of your
/// production server (and at least one backup key — see README "Certificate
/// pinning"). Leaving this `false` keeps Dio's normal, full TLS trust chain.
const bool kEnableCertificatePinning = false;

/// Allowlist of pinned **SHA-256 hashes of the full DER-encoded leaf
/// certificate**, base64-encoded, each prefixed with `sha256/`.
///
/// NOTE: this implementation pins the FULL CERTIFICATE (not the SPKI), because
/// Dart's [X509Certificate] only exposes the whole DER (`cert.der`), not the
/// SubjectPublicKeyInfo. A full-cert pin rotates whenever the cert is reissued,
/// so always pin a BACKUP certificate too. Compute a pin from a server with
/// openssl (see README "Certificate pinning"):
/// ```sh
/// openssl s_client -connect HOST:443 -servername HOST < /dev/null 2>/dev/null \
///   | openssl x509 -outform der \
///   | openssl dgst -sha256 -binary \
///   | openssl enc -base64
/// ```
/// Prefix the result with `sha256/`.
const List<String> kCertificatePins = <String>[
  // 'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
];

/// Configures Dio to pin the server's leaf certificate against
/// [kCertificatePins].
///
/// Behavior:
/// - When pinning is disabled OR the pin list is empty, this is a NO-OP — Dio
///   keeps its default adapter and full platform TLS trust. Security is never
///   weakened by the presence of this hook.
/// - When enabled with pins, a custom [IOHttpClientAdapter] is installed whose
///   `validateCertificate` only accepts a connection if the leaf certificate's
///   SHA-256 is in the allowlist. A cert that fails normal platform trust never
///   reaches this callback (we do NOT override `badCertificateCallback` to
///   accept untrusted certs), so pinning is strictly additive — it can only
///   reject, never relax, the default TLS chain validation.
class CertificatePinning {
  CertificatePinning._();

  /// Installs the pinning adapter and returns `true` when pinning is active;
  /// returns `false` (leaving [dio] untouched) when disabled or unpinned.
  static bool applyIfEnabled(
    Dio dio, {
    bool enabled = kEnableCertificatePinning,
    List<String> pins = kCertificatePins,
  }) {
    if (!enabled || pins.isEmpty) return false;

    dio.httpClientAdapter = IOHttpClientAdapter(
      validateCertificate: (cert, host, port) => isPinned(cert, pins),
    );
    return true;
  }

  /// Whether [cert]'s SHA-256 (base64, `sha256/`-prefixed) is in [pins].
  /// Visible for testing the pure comparison without a live socket.
  static bool isPinned(X509Certificate? cert, List<String> pins) {
    if (cert == null) return false;
    final fingerprint = certSha256(cert);
    final ok = pins.contains(fingerprint);
    if (!ok) {
      // Do not log the live pin set; just flag the mismatch for diagnostics.
      log.w('Certificate pin mismatch: server cert not in allowlist');
    }
    return ok;
  }

  /// `sha256/<base64>` of the full DER-encoded certificate.
  static String certSha256(X509Certificate cert) {
    final digest = sha256.convert(cert.der);
    return 'sha256/${base64Encode(digest.bytes)}';
  }
}
