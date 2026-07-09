import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

void main() {
  group('formatRupiah', () {
    test('prefixes Rp and groups thousands with dots', () {
      expect(formatRupiah(8450000), 'Rp 8.450.000');
    });

    test('does not add a separator below 1000', () {
      expect(formatRupiah(0), 'Rp 0');
      expect(formatRupiah(5), 'Rp 5');
      expect(formatRupiah(999), 'Rp 999');
    });

    test('adds a separator at exactly 1000', () {
      expect(formatRupiah(1000), 'Rp 1.000');
    });

    test('prepends a minus sign before Rp for expense amounts', () {
      expect(formatRupiah(1500, sign: '-'), '-Rp 1.500');
    });

    test('prepends a plus sign before Rp for income amounts', () {
      expect(formatRupiah(500, sign: '+'), '+Rp 500');
    });

    test(
      'formats the magnitude of a negative amount (sign is display-only)',
      () {
        expect(formatRupiah(-2000), 'Rp 2.000');
      },
    );
  });
}
