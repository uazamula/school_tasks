import 'dart:math';

import 'package:school_tasks/features/learning/data/generation/predefined_answer_selector.dart';
import 'package:school_tasks/features/learning/domain/attempts/attempt_task.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_attempt.dart';
import 'package:school_tasks/features/learning/domain/task_data/numeric_input_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data_pool.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/selection_interaction.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/tasks/numeric_input_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/selection_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/equals_evaluator.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/set_equals_evaluator.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/solution.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';

class TopicAttemptGenerator {
  TopicAttemptGenerator({
    Random? random,
    PredefinedAnswerSelector? answerSelector,
  }) : _random = random ?? Random(),
       _answerSelector = answerSelector ?? const PredefinedAnswerSelector();

  final Random _random;
  final PredefinedAnswerSelector _answerSelector;

  TopicAttempt generate(Topic topic) {
    final taskTypes = <LearningTaskType>[];

    for (final entry in topic.taskTypeCounts.entries) {
      taskTypes.addAll(List.filled(entry.value, entry.key));
    }

    taskTypes.shuffle(_random);

    final data = topic.dataSource.getData();

    final selectionDataPool = TaskDataPool<SelectionTaskData<String>>(
      items: data.whereType<SelectionTaskData<String>>().toList(),
      random: _random,
    );

    final numericInputDataPool = TaskDataPool<NumericInputTaskData>(
      items: data.whereType<NumericInputTaskData>().toList(),
      random: _random,
    );

    final tasks = taskTypes.map((type) {
      switch (type) {
        case LearningTaskType.singleChoice:
          return AttemptTask<String, String>(
            task: _createSingleChoiceTask(selectionDataPool.takeRandom()),
          );

        case LearningTaskType.numericInput:
          return AttemptTask<int, int>(
            task: _createNumericInputTask(numericInputDataPool.takeRandom()),
          );

        case LearningTaskType.multiChoice:
          return AttemptTask<List<String>, List<String>>(
            task: _createMultiChoiceTask(selectionDataPool.takeRandom()),
          );
      }
    }).toList();

    return TopicAttempt(tasks: tasks);
  }

  SelectionTask<String, String, String> _createSingleChoiceTask(
    SelectionTaskData<String> data,
  ) {
    final correctAnswers = _answerSelector.select(
      items: data.correctAnswers,
      count: 1,
      random: _random,
    );

    final wrongAnswers = _answerSelector.select(
      items: data.wrongAnswers,
      count: data.wrongAnswerCount,
      random: _random,
    );

    final options = [...correctAnswers, ...wrongAnswers]..shuffle(_random);

    return SelectionTask<String, String, String>(
      prompt: data.prompt,
      options: options,
      solution: Solution<String, String>(
        value: correctAnswers.single,
        evaluator: const EqualsEvaluator<String>(),
      ),
      mode: SelectionMode.single,
    );
  }

  NumericInputTask _createNumericInputTask(NumericInputTaskData data) {
    return NumericInputTask(
      prompt: data.prompt,
      solution: Solution<int, int>(
        value: data.correctAnswer,
        evaluator: const EqualsEvaluator<int>(),
      ),
    );
  }

  SelectionTask<String, List<String>, List<String>> _createMultiChoiceTask(
    SelectionTaskData<String> data,
  ) {
    final correctAnswers = _answerSelector.select(
      items: data.correctAnswers,
      count: data.correctAnswerCount,
      random: _random,
    );

    final wrongAnswers = _answerSelector.select(
      items: data.wrongAnswers,
      count: data.wrongAnswerCount,
      random: _random,
    );

    final options = [...correctAnswers, ...wrongAnswers]..shuffle(_random);

    return SelectionTask<String, List<String>, List<String>>(
      prompt: data.prompt,
      options: options,
      solution: Solution<List<String>, List<String>>(
        value: correctAnswers,
        evaluator: const SetEqualsEvaluator<String>(),
      ),
      mode: SelectionMode.multiple,
    );
  }
}
