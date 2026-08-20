import 'dart:math';
import 'package:school_tasks/features/learning/domain/choice_task.dart';
import 'package:school_tasks/features/learning/domain/numeric_input_task.dart';
import 'task_data.dart';

class LearningTaskGenerator {
  LearningTaskGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;

  TaskData generateAdditionData({
    required int firstMin,
    required int firstMax,
    required int secondMin,
    required int secondMax,
    required int maxSum,
  }) {
    int firstNumber;
    int secondNumber;

    do {
      firstNumber = firstMin + _random.nextInt(firstMax - firstMin + 1);
      secondNumber = secondMin + _random.nextInt(secondMax - secondMin + 1);
    } while (firstNumber + secondNumber > maxSum);

    final correctAnswer = firstNumber + secondNumber;

    return TaskData(
      condition: '$firstNumber + $secondNumber = ?',
      correctAnswer: correctAnswer,
    );
  }

  ChoiceTask createChoiceTask(TaskData data) {
    return ChoiceTask(
      condition: data.condition,
      correctAnswer: data.correctAnswer,
      answers: data.answers!,
    );
  }

  NumericInputTask createNumericInputTask(TaskData data) {
    return NumericInputTask(
      condition: data.condition,
      correctAnswer: data.correctAnswer,
    );
  }

  List<int> generateChoiceAnswers(int correctAnswer) {
    final answers = <int>{correctAnswer};

    while (answers.length < 4) {
      answers.add(_random.nextInt(9) + 1);
    }

    return answers.toList()..shuffle(_random);
  }
}
