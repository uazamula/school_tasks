import 'dart:math';

import 'package:school_tasks/features/learning/data/generation/task_data_generator.dart';
import 'package:school_tasks/features/learning/domain/choice_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data.dart';

import '../wrong_answer_generator.dart';
import 'addition_generator_config.dart';

class AdditionTaskDataGenerator extends TaskDataGenerator {
  AdditionTaskDataGenerator({
    required this.config,
    WrongAnswerGenerator? wrongAnswerGenerator,
    Random? random,
  }) : _wrongAnswerGenerator =
           wrongAnswerGenerator ?? const WrongAnswerGenerator(),
       _random = random ?? Random();

  final AdditionGeneratorConfig config;
  final WrongAnswerGenerator _wrongAnswerGenerator;
  final Random _random;

  @override
  List<TaskData> generate() {
    final result = <ChoiceTaskData>[];

    final valuesA = _generateValues(
      minimum: config.minA,
      maximum: config.maxA,
      divisibility: config.divisibilityA,
    );

    final valuesB = _generateValues(
      minimum: config.minB,
      maximum: config.maxB,
      divisibility: config.divisibilityB,
    );

    for (final a in valuesA) {
      for (final b in valuesB) {
        final correctAnswer = a + b;

        // Перевіряємо саме діапазон правильних відповідей.
        if (correctAnswer < config.minimumResult ||
            correctAnswer > config.maximumResult) {
          continue;
        }

        if (config.resultDivisibility != null &&
            correctAnswer % config.resultDivisibility! != 0) {
          continue;
        }

        final wrongAnswers = _wrongAnswerGenerator.generate(
          correctAnswer: correctAnswer,
          minimumResult: config.effectiveWrongAnswerMinimumResult,
          maximumResult: config.effectiveWrongAnswerMaximumResult,
          count: config.wrongAnswerCount,
          divisibility: config.wrongAnswerDivisibility,
          strategy: config.wrongAnswerStrategy,
          random: _random,
        );

        final answers = [correctAnswer, ...wrongAnswers]..shuffle(_random);

        result.add(
          ChoiceTaskData(
            condition: 'Скільки буде $a + $b?',
            correctAnswer: correctAnswer,
            answers: answers,
          ),
        );
      }
    }

    return result;
  }

  List<int> _generateValues({
    required int minimum,
    required int maximum,
    int? divisibility,
  }) {
    if (minimum > maximum) {
      return [];
    }

    if (divisibility == null) {
      return [for (var value = minimum; value <= maximum; value++) value];
    }

    if (divisibility <= 0) {
      throw ArgumentError('Divisibility must be greater than zero.');
    }

    return [
      for (var value = minimum; value <= maximum; value++)
        if (value % divisibility == 0) value,
    ];
  }
}
