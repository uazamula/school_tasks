import 'dart:math';

import 'package:school_tasks/features/learning/data/generation/multiplication/multiplication_generator_config.dart';
import 'package:school_tasks/features/learning/data/generation/task_data_generator.dart';
import 'package:school_tasks/features/learning/domain/task_data/selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

import '../wrong_answer_generator.dart';
import 'multiplication_prompt_type.dart';

class MultiplicationTaskDataGenerator extends TaskDataGenerator {
  MultiplicationTaskDataGenerator({
    required this.config,
    required this.promptType,
    this.gridItem,
    WrongAnswerGenerator? wrongAnswerGenerator,
    Random? random,
  }) : _wrongAnswerGenerator =
           wrongAnswerGenerator ?? const WrongAnswerGenerator(),
       _random = random ?? Random();

  final MultiplicationGeneratorConfig config;
  final MultiplicationPromptType promptType;
  final TaskContent? gridItem;

  final WrongAnswerGenerator _wrongAnswerGenerator;
  final Random _random;

  @override
  List<TaskData> generate() {
    final result = <SelectionTaskData<String>>[];

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
        final correctAnswer = a * b;

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

        result.add(
          SelectionTaskData<String>(
            prompt: _buildPrompt(a, b),
            correctAnswers: [correctAnswer.toString()],
            wrongAnswers: [
              for (final answer in wrongAnswers) answer.toString(),
            ],
            wrongAnswerCount: config.wrongAnswerCount,
          ),
        );
      }
    }

    return result;
  }

  TaskPrompt _buildPrompt(int a, int b) {
    switch (promptType) {
      case MultiplicationPromptType.text:
        return TaskPrompt(content: [TextContent('Скільки буде $a × $b?')]);

      case MultiplicationPromptType.grid:
        if (gridItem == null) {
          throw StateError('gridItem is required when promptType is grid.');
        }

        return TaskPrompt(
          content: [
            TextContent('Скільки предметів на малюнку?'),
            GeneratedGridContent(rows: a, columns: b, item: gridItem!),
          ],
        );
    }
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
