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

    for (var a = config.minA; a <= config.maxA; a++) {
      for (var b = config.minB; b <= config.maxB; b++) {
        final correctAnswer = a + b;

        // Перевіряємо саме діапазон правильних відповідей.
        if (correctAnswer < config.minimumResult ||
            correctAnswer > config.maximumResult) {
          continue;
        }

        final wrongAnswers = _wrongAnswerGenerator.generate(
          correctAnswer: correctAnswer,
          minimumResult: config.effectiveWrongAnswerMinimumResult,
          maximumResult: config.effectiveWrongAnswerMaximumResult,
          count: config.wrongAnswerCount,
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
}
