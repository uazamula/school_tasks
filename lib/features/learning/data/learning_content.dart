import 'package:school_tasks/features/learning/domain/learning_node.dart';
import 'package:school_tasks/features/learning/domain/learning_node_type.dart';
import 'package:school_tasks/features/learning/domain/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/task_data.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';

abstract final class LearningContent {
  static const List<LearningNode> items = [
    LearningNode(
      id: 'grade_1',
      titleKey: 'grade1',
      type: LearningNodeType.knowledgeLevel,
      children: [
        LearningNode(
          id: 'addition',
          titleKey: 'addition',
          type: LearningNodeType.section,
          children: [
            LearningNode(
              id: 'addition_within_10',
              titleKey: 'additionWithin10',
              type: LearningNodeType.topic,
            ),
          ],
        ),
      ],
    ),
  ];

  static const List<Topic> topics = [
    Topic(
      id: 'addition_within_10',
      taskTypeCounts: {
        LearningTaskType.choice: 2,
        LearningTaskType.numericInput: 2,
      },
      firstMin: 1,
      firstMax: 8,
      secondMin: 1,
      secondMax: 8,
      maxSum: 9,
    ),
  ];

  static const List<TaskData> additionWithin10Data = [
    TaskData(condition: 'Скільки буде 2 + 2?', correctAnswer: 4),
    TaskData(condition: 'Скільки буде 3 + 4?', correctAnswer: 7),
    TaskData(condition: 'Скільки буде 1 + 5?', correctAnswer: 6),
    TaskData(condition: 'Скільки буде 2 + 6?', correctAnswer: 8),
    TaskData(condition: 'Скільки буде 1 + 1?', correctAnswer: 2),
  ];
}
