import 'dart:math';
import 'package:school_tasks/features/learning/domain/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/task_data.dart';
import 'attempt_task.dart';
import 'learning_task_generator.dart';
import 'topic.dart';
import 'topic_attempt.dart';
import 'task_data_pool.dart';

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

    final dataPool = _createDataPool(topic);

    final tasks = taskTypes
        .map((type) => _generateTask(type, dataPool))
        .toList();

    return TopicAttempt(tasks: tasks);
  }

  TaskDataPool<TaskData> _createDataPool(Topic topic) {
    final data = <TaskData>[];

    final requiredDataCount = topic.taskTypeCounts.values.fold(
      0,
      (sum, count) => sum + count,
    );

    for (var i = 0; i < requiredDataCount; i++) {
      data.add(
        _taskGenerator.generateAdditionData(
          firstMin: topic.firstMin,
          firstMax: topic.firstMax,
          secondMin: topic.secondMin,
          secondMax: topic.secondMax,
          maxSum: topic.maxSum,
        ),
      );
    }

    return TaskDataPool(items: data, random: _random);
  }

  AttemptTask _generateTask(
    LearningTaskType type,
    TaskDataPool<TaskData> dataPool,
  ) {
    final data = dataPool.takeRandom();

    switch (type) {
      case LearningTaskType.choice:
        final taskData = data.copyWith(
          answers: _taskGenerator.generateChoiceAnswers(data.correctAnswer),
        );

        return AttemptTask(task: _taskGenerator.createChoiceTask(taskData));

      case LearningTaskType.numericInput:
        return AttemptTask(task: _taskGenerator.createNumericInputTask(data));
    }
  }
}
