import 'dart:math';

import 'package:school_tasks/features/learning/domain/attempt_task.dart';
import 'package:school_tasks/features/learning/domain/choice_task_data.dart';
import 'package:school_tasks/features/learning/domain/equals_evaluator.dart';
import 'package:school_tasks/features/learning/domain/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/multi_choice_task_data.dart';
import 'package:school_tasks/features/learning/domain/numeric_input_task.dart';
import 'package:school_tasks/features/learning/domain/numeric_input_task_data.dart';
import 'package:school_tasks/features/learning/domain/selection_task.dart';
import 'package:school_tasks/features/learning/domain/selection_interaction.dart';
import 'package:school_tasks/features/learning/domain/set_equals_evaluator.dart';
import 'package:school_tasks/features/learning/domain/solution.dart';
import 'package:school_tasks/features/learning/domain/task_data_pool.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_attempt.dart';

class TopicAttemptGenerator {
  TopicAttemptGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;

  TopicAttempt generate(Topic topic) {
    final taskTypes = <LearningTaskType>[];

    for (final entry in topic.taskTypeCounts.entries) {
      taskTypes.addAll(List.filled(entry.value, entry.key));
    }

    taskTypes.shuffle(_random);

    final data = topic.dataSource.getData();

    final choiceDataPool = TaskDataPool<ChoiceTaskData>(
      items: data.whereType<ChoiceTaskData>().toList(),
      random: _random,
    );

    final numericInputDataPool = TaskDataPool<NumericInputTaskData>(
      items: data.whereType<NumericInputTaskData>().toList(),
      random: _random,
    );

    final multiChoiceDataPool = TaskDataPool<MultiChoiceTaskData>(
      items: data.whereType<MultiChoiceTaskData>().toList(),
      random: _random,
    );

    final tasks = taskTypes.map((type) {
      switch (type) {
        case LearningTaskType.choice:
          return AttemptTask<int, int>(
            task: _createChoiceTask(choiceDataPool.takeRandom()),
          );

        case LearningTaskType.numericInput:
          return AttemptTask<int, int>(
            task: _createNumericInputTask(numericInputDataPool.takeRandom()),
          );

        case LearningTaskType.multiChoice:
          return AttemptTask<List<String>, List<String>>(
            task: _createMultiChoiceTask(multiChoiceDataPool.takeRandom()),
          );
      }
    }).toList();

    return TopicAttempt(tasks: tasks);
  }

  SelectionTask<int, int, int> _createChoiceTask(ChoiceTaskData data) {
    return SelectionTask<int, int, int>(
      prompt: data.prompt,
      options: data.answers,
      solution: Solution<int, int>(
        value: data.correctAnswer,
        evaluator: const EqualsEvaluator<int>(),
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
    MultiChoiceTaskData data,
  ) {
    final options = [...data.correctAnswers, ...data.wrongAnswers]
      ..shuffle(_random);

    return SelectionTask<String, List<String>, List<String>>(
      prompt: data.prompt,
      options: options,
      solution: Solution<List<String>, List<String>>(
        value: data.correctAnswers,
        evaluator: const SetEqualsEvaluator<String>(),
      ),
      mode: SelectionMode.multiple,
    );
  }
}
