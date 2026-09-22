import 'dart:math';

import 'package:school_tasks/features/learning/data/generation/task_data_generator.dart';
import 'package:school_tasks/features/learning/data/generation/wrong_answer_generator.dart';
import 'package:school_tasks/features/learning/domain/rational.dart';
import 'package:school_tasks/features/learning/domain/task_data/input_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_mode.dart';

import 'arithmetic_generator_config.dart';
import 'arithmetic_operation.dart';

class ArithmeticTaskDataGenerator extends TaskDataGenerator {
  ArithmeticTaskDataGenerator({
    required this.config,
    required this.operation,
    this.imageForGrid,
    this.inputMode,
    WrongAnswerGenerator? wrongAnswerGenerator,
    Random? random,
  }) : _wrongAnswerGenerator =
           wrongAnswerGenerator ?? const WrongAnswerGenerator(),
       _random = random ?? Random();

  final ArithmeticGeneratorConfig config;
  final ArithmeticOperation operation;
  final String? imageForGrid;
  final InputMode? inputMode;

  final WrongAnswerGenerator _wrongAnswerGenerator;
  final Random _random;

  @override
  List<TaskData> generate() {
    final result = <TaskData>[];

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
        final correctAnswer = _calculateResult(a, b);

        if (correctAnswer < config.minimumResult ||
            correctAnswer > config.maximumResult) {
          continue;
        }

        if (config.resultDivisibility != null &&
            correctAnswer % config.resultDivisibility! != 0) {
          continue;
        }

        final prompt = _createPrompt(a, b);

        if (inputMode != null) {
          result.add(
            InputTaskData(
              prompt: prompt,
              correctAnswer: Rational(correctAnswer),
              inputMode: inputMode!,
            ),
          );
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

        result.add(
          SelectionTaskData<String>(
            prompt: prompt,
            correctAnswers: [correctAnswer.toString()],
            wrongAnswers: [
              for (final answer in wrongAnswers) answer.toString(),
            ],
            correctAnswerCount: 1,
            wrongAnswerCount: config.wrongAnswerCount,
          ),
        );
      }
    }

    return result;
  }

  int _calculateResult(int a, int b) {
    switch (operation) {
      case ArithmeticOperation.addition:
        return a + b;
      case ArithmeticOperation.multiplication:
        return a * b;
    }
  }

  TaskPrompt _createPrompt(int a, int b) {
    if (operation == ArithmeticOperation.multiplication &&
        imageForGrid != null) {
      return TaskPrompt(
        content: [
          const TextContent('Скільки предметів на малюнку?'),
          GridContent(rows: a, columns: b, item: ImageContent(imageForGrid!)),
        ],
      );
    }

    final operator = switch (operation) {
      ArithmeticOperation.addition => '+',
      ArithmeticOperation.multiplication => '×',
    };

    return TaskPrompt(content: [TextContent('Скільки буде $a $operator $b?')]);
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
