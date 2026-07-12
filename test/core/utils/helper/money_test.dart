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

  group('formatCompactRupiah', () {
    test('falls back to full formatRupiah below 1000 (incl. 0)', () {
      expect(formatCompactRupiah(0), 'Rp 0');
      expect(formatCompactRupiah(999), 'Rp 999');
    });

    test('uses ribu (rb) units in the thousands', () {
      expect(formatCompactRupiah(1000), '1rb');
      expect(formatCompactRupiah(12000), '12rb');
    });

    test('uses juta (jt) units in the millions with one decimal', () {
      expect(formatCompactRupiah(1500000), '1,5jt');
      expect(formatCompactRupiah(8450000), '8,5jt');
    });

    test('rounds the scaled value half-up at the boundary', () {
      // 1_950_000 / 1e6 = 1.95 → round(19.5) = 20 → 2,0 → "2jt".
      expect(formatCompactRupiah(1950000), '2jt');
    });

    test('uses miliar (M) units in the billions', () {
      expect(formatCompactRupiah(2500000000), '2,5M');
    });

    test('keeps the sign for a negative compact amount', () {
      expect(formatCompactRupiah(-12000), '-12rb');
    });
  });

  group('groupDigits', () {
    test('groups thousands with dots', () {
      expect(groupDigits('1000000'), '1.000.000');
    });

    test('leaves runs below 1000 ungrouped', () {
      expect(groupDigits('0'), '0');
      expect(groupDigits('999'), '999');
    });

    test('adds a separator at exactly four digits', () {
      expect(groupDigits('1000'), '1.000');
    });

    test('returns an empty string for empty input', () {
      expect(groupDigits(''), '');
    });
  });
}
