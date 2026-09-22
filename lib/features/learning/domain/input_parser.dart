import 'package:school_tasks/features/learning/domain/rational.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_mode.dart';

class InputParser {
  const InputParser._();

  static Rational parse(String input, InputMode mode) {
    if (input.isEmpty) {
      throw const FormatException('Input cannot be empty.');
    }

    switch (mode) {
      case InputMode.integer:
        return _parseInteger(input);

      case InputMode.decimal:
        return _parseDecimal(input);
    }
  }

  static Rational _parseInteger(String input) {
    final value = int.tryParse(input);

    if (value == null) {
      throw FormatException('Invalid integer: $input');
    }

    return Rational(value);
  }

  static Rational _parseDecimal(String input) {
    final parts = input.split('.');

    if (parts.length != 2) {
      final value = int.tryParse(input);

      if (value == null) {
        throw FormatException('Invalid decimal: $input');
      }

      return Rational(value);
    }

    final wholePart = parts[0];
    final fractionalPart = parts[1];

    if (fractionalPart.isEmpty || !RegExp(r'^\d+$').hasMatch(fractionalPart)) {
      throw FormatException('Invalid decimal: $input');
    }

    final whole = int.tryParse(wholePart);

    if (whole == null) {
      throw FormatException('Invalid decimal: $input');
    }

    final fractional = int.parse(fractionalPart);
    final denominator = _powerOfTen(fractionalPart.length);
    final numerator = whole * denominator + fractional;

    return Rational(numerator, denominator);
  }

  static int _powerOfTen(int exponent) {
    var result = 1;

    for (var i = 0; i < exponent; i++) {
      result *= 10;
    }

    return result;
  }
}
