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
              id: 'addition_digits',
              titleKey: 'additionDigits',
              type: LearningNodeType.topic,
            ),
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

  static const List<TaskData> additionWithin10Data = [
    TaskData(
      condition: 'Скільки буде 2 + 2?',
      correctAnswer: 4,
      answers: [1, 3, 4, 7],
    ),
    TaskData(
      condition: 'Скільки буде 3 + 4?',
      correctAnswer: 7,
      answers: [3, 5, 7, 8],
    ),
    TaskData(
      condition: 'Скільки буде 1 + 5?',
      correctAnswer: 6,
      answers: [4, 5, 6, 8],
    ),
    TaskData(
      condition: 'Скільки буде 2 + 6?',
      correctAnswer: 8,
      answers: [5, 6, 7, 8],
    ),
    TaskData(
      condition: 'Скільки буде 1 + 1?',
      correctAnswer: 2,
      answers: [1, 2, 3, 4],
    ),
  ];

  static const List<TaskData> additionDigitsData = [
    TaskData(
      condition: 'Скільки буде 2 + 9?',
      correctAnswer: 11,
      answers: [11, 13, 14, 17],
    ),
    TaskData(
      condition: 'Скільки буде 3 + 10?',
      correctAnswer: 13,
      answers: [3, 10, 11, 13],
    ),
    TaskData(
      condition: 'Скільки буде 6 + 5?',
      correctAnswer: 11,
      answers: [10, 11, 12, 13],
    ),
  ];
  static const List<Topic> topics = [
    Topic(
      id: 'addition_within_10',
      taskTypeCounts: {
        LearningTaskType.choice: 2,
        LearningTaskType.numericInput: 2,
      },
      taskData: additionWithin10Data,
      help: 'Тут буде довідка про додавання в межах 10.',
    ),
    Topic(
      id: 'addition_digits',
      taskTypeCounts: {LearningTaskType.choice: 2},
      taskData: additionDigitsData,
      help: 'Тут буде довідка про додавання одноцифрових чисел.',
    ),
  ];
}
