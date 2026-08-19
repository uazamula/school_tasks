import 'dart:math';

import 'package:school_tasks/features/learning/domain/learning_type_task.dart';
import 'attempt_task.dart';
import 'learning_task_generator.dart';
import 'topic.dart';
import 'topic_attempt.dart';

class TopicAttemptGenerator {
  TopicAttemptGenerator({LearningTaskGenerator? taskGenerator, Random? random})
    : _taskGenerator = taskGenerator ?? LearningTaskGenerator(),
      _random = random ?? Random();

  final LearningTaskGenerator _taskGenerator;
  final Random _random;

  TopicAttempt generate(Topic topic) {
    final taskTypes = <LearningTaskType>[];

    for (final entry in topic.taskTypeCounts.entries) {
      taskTypes.addAll(List.filled(entry.value, entry.key));
    }

    taskTypes.shuffle(_random);

    final tasks = taskTypes.map(_generateTask).toList();

    return TopicAttempt(tasks: tasks);
  }

  AttemptTask _generateTask(LearningTaskType type) {
    switch (type) {
      case LearningTaskType.choice:
        return AttemptTask(task: _taskGenerator.generateAdditionWithin10());

      case LearningTaskType.numericInput:
        return AttemptTask(
          task: _taskGenerator.generateAdditionWithin10NumericInput(),
        );
    }
  }
}
