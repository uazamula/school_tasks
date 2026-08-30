import 'dart:math';

import 'package:school_tasks/features/learning/domain/attempt_task.dart';
import 'package:school_tasks/features/learning/domain/choice_task.dart';
import 'package:school_tasks/features/learning/domain/choice_task_data.dart';
import 'package:school_tasks/features/learning/domain/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/multi_choice_task.dart';
import 'package:school_tasks/features/learning/domain/multi_choice_task_data.dart';
import 'package:school_tasks/features/learning/domain/numeric_input_task.dart';
import 'package:school_tasks/features/learning/domain/numeric_input_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data_pool.dart';
import 'package:school_tasks/features/learning/domain/task_content.dart';
import 'package:school_tasks/features/learning/domain/task_prompt.dart';
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
          return AttemptTask(
            task: _createChoiceTask(choiceDataPool.takeRandom()),
          );

        case LearningTaskType.numericInput:
          return AttemptTask(
            task: _createNumericInputTask(numericInputDataPool.takeRandom()),
          );

        case LearningTaskType.multiChoice:
          return AttemptTask(
            task: _createMultiChoiceTask(multiChoiceDataPool.takeRandom()),
          );
      }
    }).toList();

    return TopicAttempt(tasks: tasks);
  }

  ChoiceTask _createChoiceTask(ChoiceTaskData data) {
    return ChoiceTask(
      prompt: TaskPrompt(content: [TextContent(data.condition)]),
      correctAnswer: data.correctAnswer,
      answers: data.answers,
    );
  }

  NumericInputTask _createNumericInputTask(NumericInputTaskData data) {
    return NumericInputTask(
      prompt: TaskPrompt(content: [TextContent(data.condition)]),
      correctAnswer: data.correctAnswer,
    );
  }

  MultiChoiceTask _createMultiChoiceTask(MultiChoiceTaskData data) {
    final answers = [...data.correctAnswers, ...data.wrongAnswers]
      ..shuffle(_random);

    final content = <TaskContent>[TextContent(data.condition)];

    if (data.imagePath != null) {
      content.add(ImageContent(data.imagePath!));
    }

    return MultiChoiceTask(
      prompt: TaskPrompt(content: content),
      answers: answers,
      correctAnswers: data.correctAnswers,
    );
  }
}
