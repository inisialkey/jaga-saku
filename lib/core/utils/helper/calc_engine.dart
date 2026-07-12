import 'package:jaga_saku/core/utils/helper/money.dart';

/// Pure, Flutter-free calculator for the amount keypad (V2-M3). Mirrors the
/// `TransactionAggregator` / `BudgetStatus` precedent: a class with a private
/// const constructor and static methods, unit-tested in isolation.
///
/// Deliberately a *cheap calculator*, not a scientific one:
/// * operators are stored ASCII `+ - * /` (glyphs `× ÷ −` are display-only,
///   applied by [format]);
/// * evaluation is strictly **left-to-right, no precedence** (`2+3*4 == 20`);
/// * every division rounds to the nearest integer rupiah (`10000/3 == 3333`);
/// * division by zero, an empty/garbage expression, or a lone operator all
///   resolve to `0`;
/// * a leading operator seeds the accumulator at `0`, so re-editable negatives
///   work without a unary parser (`-150 == -150`, `-150+5 == -145`).
//
// ponytail: left-to-right only by design (task scope). Add real precedence
// only if a future milestone asks for it.
class CalcEngine {
  const CalcEngine._();

  static const Set<String> _operators = {'+', '-', '*', '/'};

  /// Evaluates [expr] to a signed integer. Invalid/empty input → `0`.
  static int evaluate(String expr) {
    final tokens = _tokenize(expr);
    // Drop a trailing operator ("12000+" → 12000).
    if (tokens.isNotEmpty && tokens.last is String) tokens.removeLast();
    if (tokens.isEmpty) return 0;

    // A leading operator seeds acc = 0 (re-editable negatives); otherwise the
    // first number is the accumulator.
    var acc = 0;
    var index = 0;
    if (tokens.first is int) {
      acc = tokens.first as int;
      index = 1;
    }
    // Fold the remaining (operator, operand) pairs left-to-right.
    while (index + 1 < tokens.length) {
      acc = _apply(acc, tokens[index] as String, tokens[index + 1] as int);
      index += 2;
    }
    return acc;
  }

  /// Renders [expr] for the keypad's expression line: groups each digit run via
  /// [groupDigits] and swaps ASCII operators for their display glyphs.
  /// `format('12000+3500')` → `12.000+3.500`, `format('1000000')` →
  /// `1.000.000`, `format('')` → `''`.
  static String format(String expr) {
    final out = StringBuffer();
    final number = StringBuffer();
    void flush() {
      if (number.isNotEmpty) {
        out.write(groupDigits(number.toString()));
        number.clear();
      }
    }

    for (var i = 0; i < expr.length; i++) {
      final ch = expr[i];
      if (_isDigit(ch)) {
        number.write(ch);
      } else {
        flush();
        out.write(_glyph(ch));
      }
    }
    flush();
    return out.toString();
  }

  /// Splits [expr] into an ordered list of `int` operands and `String`
  /// operators. Unknown characters (letters, spaces, glyphs) are ignored, and
  /// adjacent operators collapse to the last one (`1++2` → `1 + 2`).
  static List<Object> _tokenize(String expr) {
    final tokens = <Object>[];
    final number = StringBuffer();
    void flush() {
      if (number.isEmpty) return;
      final value = int.tryParse(number.toString());
      if (value != null) tokens.add(value);
      number.clear();
    }

    for (var i = 0; i < expr.length; i++) {
      final ch = expr[i];
      if (_isDigit(ch)) {
        number.write(ch);
      } else if (_operators.contains(ch)) {
        flush();
        if (tokens.isNotEmpty && tokens.last is String) {
          tokens[tokens.length - 1] = ch; // collapse adjacent operators
        } else {
          tokens.add(ch);
        }
      }
      // Any other character is ignored ("abc" → no tokens → 0).
    }
    flush();
    return tokens;
  }

  static int _apply(int a, String op, int b) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        return b == 0 ? 0 : (a / b).round();
      default:
        return a; // unreachable: op is always from _operators
    }
  }

  static String _glyph(String op) {
    switch (op) {
      case '-':
        return '−'; // − MINUS SIGN
      case '*':
        return '×'; // × MULTIPLICATION SIGN
      case '/':
        return '÷'; // ÷ DIVISION SIGN
      default:
        return op; // '+' and any stray character pass through
    }
  }

  static bool _isDigit(String ch) {
    final code = ch.codeUnitAt(0);
    return code >= 0x30 && code <= 0x39; // '0'..'9'
  }
}
