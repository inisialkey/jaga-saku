import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/theme/text_theme.dart';
import 'package:jaga_saku/core/utils/ext/text_theme.dart';

void main() {
  final textTheme = AppTextTheme.build(const Color(0xFF000000));

  group('TextThemeExtension', () {
    test('titleLargeBold keeps titleLarge metrics but forces bold weight', () {
      final style = textTheme.titleLargeBold;
      expect(style?.fontWeight, FontWeight.bold);
      expect(style?.fontSize, textTheme.titleLarge?.fontSize);
    });

    test('bodyMedium500 keeps bodyMedium metrics but forces w500 weight', () {
      final style = textTheme.bodyMedium500;
      expect(style?.fontWeight, FontWeight.w500);
      expect(style?.fontSize, textTheme.bodyMedium?.fontSize);
    });
  });
}
