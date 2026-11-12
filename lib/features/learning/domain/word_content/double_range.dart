/// Діапазон дробових значень з необов'язковими межами (обидві включно).
///
/// `DoubleRange(min: 0.9, max: 1.1)`, `DoubleRange.atLeast(1.1)`,
/// `DoubleRange.atMost(0.9)`.
class DoubleRange {
  const DoubleRange({this.min, this.max})
    : assert(min == null || max == null || min <= max);

  const DoubleRange.atLeast(double value) : min = value, max = null;

  const DoubleRange.atMost(double value) : min = null, max = value;

  /// Нижня межа (включно). null — без обмеження.
  final double? min;

  /// Верхня межа (включно). null — без обмеження.
  final double? max;

  bool contains(double value) {
    final lower = min;
    final upper = max;
    return (lower == null || value >= lower) &&
        (upper == null || value <= upper);
  }

  @override
  String toString() {
    if (min != null && max != null) return '$min..$max';
    if (min != null) return '≥$min';
    if (max != null) return '≤$max';
    return 'будь-яке';
  }
}
