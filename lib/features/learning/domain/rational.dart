class Rational implements Comparable<Rational> {
  Rational(int numerator, [int denominator = 1])
    : assert(denominator != 0),
      numerator = _normalizeNumerator(numerator, denominator),
      denominator = _normalizeDenominator(numerator, denominator) {
    if (denominator == 0) {
      throw ArgumentError('Denominator cannot be zero.');
    }
  }

  final int numerator;
  final int denominator;

  static int _normalizeNumerator(int numerator, int denominator) {
    final divisor = _gcd(numerator.abs(), denominator.abs());

    if (denominator < 0) {
      return -numerator ~/ divisor;
    }

    return numerator ~/ divisor;
  }

  static int _normalizeDenominator(int numerator, int denominator) {
    final divisor = _gcd(numerator.abs(), denominator.abs());

    return denominator.abs() ~/ divisor;
  }

  static int _gcd(int a, int b) {
    while (b != 0) {
      final remainder = a % b;
      a = b;
      b = remainder;
    }

    return a == 0 ? 1 : a;
  }

  Rational operator +(Rational other) {
    return Rational(
      numerator * other.denominator + other.numerator * denominator,
      denominator * other.denominator,
    );
  }

  Rational operator -(Rational other) {
    return Rational(
      numerator * other.denominator - other.numerator * denominator,
      denominator * other.denominator,
    );
  }

  Rational operator *(Rational other) {
    return Rational(
      numerator * other.numerator,
      denominator * other.denominator,
    );
  }

  Rational operator /(Rational other) {
    if (other.numerator == 0) {
      throw ArgumentError('Cannot divide by zero.');
    }

    return Rational(
      numerator * other.denominator,
      denominator * other.numerator,
    );
  }

  Rational get abs => Rational(numerator.abs(), denominator);

  @override
  int compareTo(Rational other) {
    final left = numerator * other.denominator;
    final right = other.numerator * denominator;

    return left.compareTo(right);
  }

  @override
  bool operator ==(Object other) {
    return other is Rational &&
        numerator == other.numerator &&
        denominator == other.denominator;
  }

  @override
  int get hashCode => Object.hash(numerator, denominator);

  @override
  String toString() {
    if (denominator == 1) {
      return numerator.toString();
    }

    return '$numerator/$denominator';
  }
}
