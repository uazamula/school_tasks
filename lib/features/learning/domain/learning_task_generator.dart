import 'dart:math';
import 'package:school_tasks/features/learning/domain/choice_task.dart';
import 'package:school_tasks/features/learning/domain/numeric_input_task.dart';
import 'addition_task_data.dart';

class LearningTaskGenerator {
  LearningTaskGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;

  ChoiceTask generateAdditionChoice({
    required int firstMin,
    required int firstMax,
    required int secondMin,
    required int secondMax,
    required int maxSum,
  }) {
    final data = _generateAdditionData(
      firstMin: firstMin,
      firstMax: firstMax,
      secondMin: secondMin,
      secondMax: secondMax,
      maxSum: maxSum,
    );

    return ChoiceTask(
      condition: data.condition,
      correctAnswer: data.correctAnswer,
      answers: _generateChoiceAnswers(data.correctAnswer),
    );
  }

  NumericInputTask generateAdditionNumericInput({
    required int firstMin,
    required int firstMax,
    required int secondMin,
    required int secondMax,
    required int maxSum,
  }) {
    final data = _generateAdditionData(
      firstMin: firstMin,
      firstMax: firstMax,
      secondMin: secondMin,
      secondMax: secondMax,
      maxSum: maxSum,
    );

    return NumericInputTask(
      condition: data.condition,
      correctAnswer: data.correctAnswer,
    );
  }

  AdditionTaskData _generateAdditionData({
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

    return AdditionTaskData(
      firstNumber: firstNumber,
      secondNumber: secondNumber,
    );
  }

  // TODO частина нижче потребує переробки
  List<int> _generateChoiceAnswers(int correctAnswer) {
    final answers = <int>{correctAnswer};

    while (answers.length < 4) {
      answers.add(_random.nextInt(9) + 1);
    }

    return answers.toList()..shuffle(_random);
  }
}
