import 'dart:math';
import 'package:school_tasks/features/learning/domain/attempt_task.dart';
import 'package:school_tasks/features/learning/domain/choice_task.dart';
import 'package:school_tasks/features/learning/domain/choice_task_data.dart';
import 'package:school_tasks/features/learning/domain/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/numeric_input_task.dart';
import 'package:school_tasks/features/learning/domain/numeric_input_task_data.dart';
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

    final choiceDataPool = TaskDataPool<ChoiceTaskData>(
      items: topic.taskData.whereType<ChoiceTaskData>().toList(),
      random: _random,
    );

    final numericInputDataPool = TaskDataPool<NumericInputTaskData>(
      items: topic.taskData.whereType<NumericInputTaskData>().toList(),
      random: _random,
    );

    final tasks = taskTypes.map((type) {
      switch (type) {
        case LearningTaskType.choice:
          return AttemptTask(
            task: _createChoiceTask(choiceDataPool.takeRandom()),
          );

        case LearningTaskType.numericInput:
          return AttemptTask(
            task: _createNumericInputTask(numericInputDataPool.takeRandom()),
          );
      }
    }).toList();

    return TopicAttempt(tasks: tasks);
  }

  ChoiceTask _createChoiceTask(ChoiceTaskData data) {
    return ChoiceTask(
      condition: data.condition,
      correctAnswer: data.correctAnswer,
      answers: data.answers,
    );
  }

  NumericInputTask _createNumericInputTask(NumericInputTaskData data) {
    return NumericInputTask(
      condition: data.condition,
      correctAnswer: data.correctAnswer,
    );
  }
}
