import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/theme/app_colors.dart';
import 'package:jaga_saku/core/theme/app_palette.dart';

void main() {
  group('AppPalette.copyWith', () {
    test('returns an equivalent palette when no overrides are given', () {
      final copy = AppPalette.light.copyWith();
      expect(copy.income, AppPalette.light.income);
      expect(copy.surfaceSoft, AppPalette.light.surfaceSoft);
      expect(copy.border, AppPalette.light.border);
    });

    test('overrides only the provided field', () {
      final copy = AppPalette.light.copyWith(income: const Color(0xFF123456));
      expect(copy.income, const Color(0xFF123456));
      // Untouched fields are preserved.
      expect(copy.expense, AppPalette.light.expense);
      expect(copy.textSecondary, AppPalette.light.textSecondary);
    });
  });

  group('AppPalette.lerp', () {
    test('returns itself when other is null', () {
      final result = AppPalette.light.lerp(null, 0.5);
      expect(identical(result, AppPalette.light), isTrue);
    });

    test('equals the start palette at t = 0', () {
      final result = AppPalette.light.lerp(AppPalette.dark, 0);
      expect(result.surfaceSoft, AppColors.surfaceSoft);
      expect(result.border, AppColors.border);
    });

    test('equals the end palette at t = 1', () {
      final result = AppPalette.light.lerp(AppPalette.dark, 1);
      expect(result.surfaceSoft, AppColors.surfaceSoftDark);
      expect(result.border, AppColors.borderDark);
    });

    test('interpolates each token at t = 0.5', () {
      final result = AppPalette.light.lerp(AppPalette.dark, 0.5);
      expect(
        result.surfaceSoft,
        Color.lerp(AppColors.surfaceSoft, AppColors.surfaceSoftDark, 0.5),
      );
      // Tokens identical in both palettes interpolate to themselves. (income /
      // expense / transfer now differ by brightness, so use a stable token.)
      expect(result.warning, AppColors.warning);
    });
  });
}
