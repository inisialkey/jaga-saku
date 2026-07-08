import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:jaga_saku/core/network/certificate_pinning.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pure-logic tests for the certificate-pinning hook. The actual TLS handshake
/// / [X509Certificate] comparison is integration-only (needs a live socket),
/// so we test the inert-by-default contract and the null-cert guard here.
void main() {
  group('CertificatePinning.applyIfEnabled (inert when OFF)', () {
    test('disabled -> returns false and leaves Dio adapter untouched', () {
      final dio = Dio();
      final original = dio.httpClientAdapter;

      // enabled omitted -> defaults to false (kEnableCertificatePinning),
      // even though pins are present the hook must stay inert.
      final applied = CertificatePinning.applyIfEnabled(
        dio,
        pins: const ['sha256/AAAA='],
      );

      expect(applied, isFalse);
      expect(identical(dio.httpClientAdapter, original), isTrue);
    });

    test('enabled but empty pins -> returns false, adapter untouched', () {
      final dio = Dio();
      final original = dio.httpClientAdapter;

      // pins omitted -> defaults to empty (kCertificatePins); enabling without
      // pins must NOT install the adapter.
      final applied = CertificatePinning.applyIfEnabled(dio, enabled: true);

      expect(applied, isFalse);
      expect(identical(dio.httpClientAdapter, original), isTrue);
    });

    test('enabled with pins -> returns true, installs IO pinning adapter', () {
      final dio = Dio();

      final applied = CertificatePinning.applyIfEnabled(
        dio,
        enabled: true,
        pins: const ['sha256/AAAA='],
      );

      expect(applied, isTrue);
      expect(dio.httpClientAdapter, isA<IOHttpClientAdapter>());
      expect(
        (dio.httpClientAdapter as IOHttpClientAdapter).validateCertificate,
        isNotNull,
      );
    });
  });

  group('CertificatePinning.isPinned', () {
    test('null certificate is never pinned (rejected)', () {
      expect(
        CertificatePinning.isPinned(null, const ['sha256/AAAA=']),
        isFalse,
      );
    });
  });

  group('production defaults are safe (OFF)', () {
    test('kEnableCertificatePinning defaults to false', () {
      expect(kEnableCertificatePinning, isFalse);
    });

    test('kCertificatePins ships empty (placeholder only)', () {
      expect(kCertificatePins, isEmpty);
    });
  });
}
