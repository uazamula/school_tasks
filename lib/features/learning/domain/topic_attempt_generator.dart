import 'dart:math';
import 'package:school_tasks/features/learning/domain/attempt_task.dart';
import 'package:school_tasks/features/learning/domain/choice_task.dart';
import 'package:school_tasks/features/learning/domain/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/numeric_input_task.dart';
import 'package:school_tasks/features/learning/domain/task_data.dart';
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

    final dataPool = TaskDataPool<TaskData>(
      items: topic.taskData,
      random: _random,
    );

    final tasks = taskTypes
        .map((type) => _createTask(type, dataPool.takeRandom()))
        .toList();

    return TopicAttempt(tasks: tasks);
  }

  AttemptTask _createTask(LearningTaskType type, TaskData data) {
    switch (type) {
      case LearningTaskType.choice:
        assert(data.answers != null);
        return AttemptTask(
          task: ChoiceTask(
            condition: data.condition,
            correctAnswer: data.correctAnswer,
            answers: data.answers!,
          ),
        );

      case LearningTaskType.numericInput:
        return AttemptTask(
          task: NumericInputTask(
            condition: data.condition,
            correctAnswer: data.correctAnswer,
          ),
        );
    }
  }
}
