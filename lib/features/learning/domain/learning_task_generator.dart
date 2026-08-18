import 'dart:math';
import 'package:school_tasks/features/learning/domain/choice_task.dart';

class LearningTaskGenerator {
  LearningTaskGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;

  ChoiceTask generateAdditionWithin10() {
    int firstNumber;
    int secondNumber;

    do {
      firstNumber = _random.nextInt(8) + 1;
      secondNumber = _random.nextInt(8) + 1;
    } while (firstNumber + secondNumber > 9);

    final correctAnswer = firstNumber + secondNumber;

    final answers = <int>{correctAnswer};

    while (answers.length < 4) {
      answers.add(_random.nextInt(9) + 1);
    }

    final shuffledAnswers = answers.toList()..shuffle(_random);

    return ChoiceTask(
      condition: '$firstNumber + $secondNumber = ?',
      correctAnswer: correctAnswer,
      answers: shuffledAnswers,
    );
  }
}
