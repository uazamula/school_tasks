import 'dart:math';

enum WrongAnswerStrategy { randomInRange, nearest }

class WrongAnswerGenerator {
  const WrongAnswerGenerator();

  List<int> generate({
    required int correctAnswer,
    required int minimumResult,
    required int maximumResult,
    required int count,
    int? divisibility,
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

    if (divisibility != null && divisibility <= 0) {
      throw ArgumentError('divisibility must be greater than zero.');
    }

    final candidates = _buildCandidates(
      correctAnswer: correctAnswer,
      minimumResult: minimumResult,
      maximumResult: maximumResult,
      divisibility: divisibility,
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
    required int? divisibility,
    required WrongAnswerStrategy strategy,
  }) {
    switch (strategy) {
      case WrongAnswerStrategy.randomInRange:
        return [
          for (var value = minimumResult; value <= maximumResult; value++)
            if (value != correctAnswer &&
                (divisibility == null || value % divisibility == 0))
              value,
        ];

      case WrongAnswerStrategy.nearest:
        return _buildNearestCandidates(
          correctAnswer: correctAnswer,
          minimumResult: minimumResult,
          maximumResult: maximumResult,
          divisibility: divisibility,
        );
    }
  }

  List<int> _buildNearestCandidates({
    required int correctAnswer,
    required int minimumResult,
    required int maximumResult,
    required int? divisibility,
  }) {
    final candidates = <int>[];

    for (
      var distance = 1;
      candidates.length < maximumResult - minimumResult;
      distance++
    ) {
      final lower = correctAnswer - distance;
      final upper = correctAnswer + distance;

      if (lower >= minimumResult &&
          lower <= maximumResult &&
          lower != correctAnswer &&
          (divisibility == null || lower % divisibility == 0)) {
        candidates.add(lower);
      }

      if (upper >= minimumResult &&
          upper <= maximumResult &&
          upper != correctAnswer &&
          (divisibility == null || upper % divisibility == 0)) {
        candidates.add(upper);
      }

      if (lower < minimumResult && upper > maximumResult) {
        break;
      }
    }

    return candidates;
  }
}
