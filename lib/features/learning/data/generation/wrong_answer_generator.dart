import 'dart:math';

enum WrongAnswerStrategy { randomInRange, nearest }

class WrongAnswerGenerator {
  const WrongAnswerGenerator();

  List<int> generate({
    required int correctAnswer,
    required int minimumResult,
    required int maximumResult,
    required int count,
    WrongAnswerStrategy strategy = WrongAnswerStrategy.randomInRange,
    Random? random,
  }) {
    if (count <= 0) {
      return [];
    }

    if (minimumResult > maximumResult) {
      throw ArgumentError(
        'minimumResult must not be greater than maximumResult.',
      );
    }

    final candidates = _buildCandidates(
      correctAnswer: correctAnswer,
      minimumResult: minimumResult,
      maximumResult: maximumResult,
      strategy: strategy,
    );

    if (candidates.length < count) {
      throw StateError(
        'Cannot generate $count wrong answers for correct answer '
        '$correctAnswer. Only ${candidates.length} candidates available.',
      );
    }

    if (strategy == WrongAnswerStrategy.randomInRange) {
      candidates.shuffle(random ?? Random());
    }

    return candidates.take(count).toList();
  }

  List<int> _buildCandidates({
    required int correctAnswer,
    required int minimumResult,
    required int maximumResult,
    required WrongAnswerStrategy strategy,
  }) {
    switch (strategy) {
      case WrongAnswerStrategy.randomInRange:
        return [
          for (var value = minimumResult; value <= maximumResult; value++)
            if (value != correctAnswer) value,
        ];

      case WrongAnswerStrategy.nearest:
        final result = <int>[];

        for (
          var distance = 1;
          result.length < maximumResult - minimumResult;
          distance++
        ) {
          final lower = correctAnswer - distance;
          final upper = correctAnswer + distance;

          if (lower >= minimumResult) {
            result.add(lower);
          }

          if (upper <= maximumResult) {
            result.add(upper);
          }
        }

        return result;
    }
  }
}
