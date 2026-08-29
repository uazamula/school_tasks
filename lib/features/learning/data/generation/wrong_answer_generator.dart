import 'dart:math';

class WrongAnswerGenerator {
  const WrongAnswerGenerator();

  List<int> generate({
    required int correctAnswer,
    required int minimumResult,
    required int maximumResult,
    required int count,
    Random? random,
  }) {
    final rng = random ?? Random();

    final candidates = <int>[
      for (var value = minimumResult; value <= maximumResult; value++)
        if (value != correctAnswer) value,
    ];

    candidates.shuffle(rng);

    return candidates.take(count).toList();
  }
}
