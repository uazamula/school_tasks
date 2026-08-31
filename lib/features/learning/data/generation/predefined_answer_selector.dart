import 'dart:math';

class PredefinedAnswerSelector {
  const PredefinedAnswerSelector();

  List<T> select<T>({
    required List<T> items,
    required int count,
    Random? random,
  }) {
    if (count < 0) {
      throw ArgumentError('count must not be negative.');
    }

    if (count > items.length) {
      throw StateError(
        'Cannot select $count items. '
        'Only ${items.length} items available.',
      );
    }

    if (count == 0) {
      return [];
    }

    final source = List<T>.from(items);
    final result = <T>[];
    final rng = random ?? Random();

    for (var i = 0; i < count; i++) {
      final index = rng.nextInt(source.length);
      result.add(source.removeAt(index));
    }

    return result;
  }
}
