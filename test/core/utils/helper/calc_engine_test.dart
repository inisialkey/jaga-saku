import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

void main() {
  group('CalcEngine.evaluate', () {
    test('returns a lone number as-is', () {
      expect(CalcEngine.evaluate('50000'), 50000);
    });

    test('adds', () {
      expect(CalcEngine.evaluate('12000+3500'), 15500);
    });

    test('folds left-to-right with no operator precedence', () {
      expect(CalcEngine.evaluate('2+3*4'), 20);
    });

    test('rounds each division to the nearest integer rupiah', () {
      expect(CalcEngine.evaluate('10000/3'), 3333);
    });

    test('allows a negative result', () {
      expect(CalcEngine.evaluate('100-250'), -150);
    });

    test('empty expression is 0', () {
      expect(CalcEngine.evaluate(''), 0);
    });

    test('drops a trailing operator', () {
      expect(CalcEngine.evaluate('12000+'), 12000);
    });

    test('garbage input is 0', () {
      expect(CalcEngine.evaluate('abc'), 0);
    });

    test('division by zero is 0', () {
      expect(CalcEngine.evaluate('5/0'), 0);
    });

    test('a leading minus seeds a negative', () {
      expect(CalcEngine.evaluate('-150'), -150);
    });

    test('a leading minus is re-editable', () {
      expect(CalcEngine.evaluate('-150+5'), -145);
    });

    test('adjacent operators collapse to the last', () {
      expect(CalcEngine.evaluate('1++2'), 3);
    });
  });

  group('CalcEngine.format', () {
    test('groups a single number', () {
      expect(CalcEngine.format('1000000'), '1.000.000');
    });

    test('groups each operand and keeps the operator glyph', () {
      expect(CalcEngine.format('12000+3500'), '12.000+3.500');
    });

    test('maps ASCII operators to display glyphs', () {
      expect(CalcEngine.format('6*2'), '6×2');
      expect(CalcEngine.format('6/2'), '6÷2');
      expect(CalcEngine.format('9-4'), '9−4');
    });

    test('empty expression formats to empty', () {
      expect(CalcEngine.format(''), '');
    });
  });
}
