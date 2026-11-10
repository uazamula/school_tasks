/// Цілочисловий діапазон із необов'язковими межами (обидві включно).
///
/// `IntRange(min: 2, max: 4)`, `IntRange.exactly(3)`,
/// `IntRange.atLeast(2)`, `IntRange.atMost(5)`.
class IntRange {
  const IntRange({this.min, this.max})
    : assert(min == null || max == null || min <= max);

  const IntRange.exactly(int value) : min = value, max = value;

  const IntRange.atLeast(int value) : min = value, max = null;

  const IntRange.atMost(int value) : min = null, max = value;

  /// Нижня межа (включно). null — без обмеження.
  final int? min;

  /// Верхня межа (включно). null — без обмеження.
  final int? max;

  bool contains(int value) {
    final lower = min;
    final upper = max;
    return (lower == null || value >= lower) &&
        (upper == null || value <= upper);
  }

  @override
  String toString() {
    if (min != null && max != null) {
      return min == max ? '$min' : '$min..$max';
    }
    if (min != null) return '≥$min';
    if (max != null) return '≤$max';
    return 'будь-яка';
  }
}
