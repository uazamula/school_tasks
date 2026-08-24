import 'package:school_tasks/features/learning/domain/choice_task_data.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/learning_node.dart';
import 'package:school_tasks/features/learning/domain/learning_node_type.dart';
import 'package:school_tasks/features/learning/domain/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/multi_choice_task_data.dart';
import 'package:school_tasks/features/learning/domain/numeric_input_task_data.dart';
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
            LearningNode(
              id: 'shapes',
              titleKey: 'shape',
              type: LearningNodeType.topic,
            ),
          ],
        ),
      ],
    ),
  ];

  static const List<TaskData> additionWithin10Data = [
    ChoiceTaskData(
      condition: 'Скільки буде 2 + 2?',
      correctAnswer: 4,
      answers: [1, 3, 4, 7],
    ),

    NumericInputTaskData(condition: 'Скільки буде 3 + 4?', correctAnswer: 7),

    ChoiceTaskData(
      condition: 'Скільки буде 1 + 5?',
      correctAnswer: 6,
      answers: [4, 5, 6, 8],
    ),

    NumericInputTaskData(condition: 'Скільки буде 2 + 6?', correctAnswer: 8),

    NumericInputTaskData(condition: 'Скільки буде 3 + 2?', correctAnswer: 5),
  ];

  static const List<TaskData> additionDigitsData = [
    ChoiceTaskData(
      condition: 'Скільки буде 2 + 9?',
      correctAnswer: 11,
      answers: [11, 13, 14, 17],
    ),
    ChoiceTaskData(
      condition: 'Скільки буде 3 + 10?',
      correctAnswer: 13,
      answers: [3, 10, 11, 13],
    ),
    ChoiceTaskData(
      condition: 'Скільки буде 6 + 5?',
      correctAnswer: 11,
      answers: [10, 11, 12, 13],
    ),
  ];

  static const List<TaskData> shapeData = [
    MultiChoiceTaskData(
      condition: 'Що зображено на малюнку?',
      imagePath: 'assets/images/tasks/square.png',
      correctAnswers: ['Прямокутник', 'Ромб', 'Паралелограм'],
      wrongAnswers: ['Коло'],
    ),
    MultiChoiceTaskData(
      condition: 'Що є паралелограмом завжди?',
      correctAnswers: ['Прямокутник', 'Квадрат'],
      wrongAnswers: ['Трапеція', 'Коло'],
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
      evaluation: EvaluationConfig(accuracyWeight: 1.0),
    ),
    Topic(
      id: 'addition_digits',
      taskTypeCounts: {LearningTaskType.choice: 2},
      taskData: additionDigitsData,
      help: 'Тут буде довідка про додавання одноцифрових чисел.',
      evaluation: EvaluationConfig(accuracyWeight: 1.0),
    ),
    Topic(
      id: 'shapes',
      taskTypeCounts: {
        LearningTaskType.multiChoice: 1,
        LearningTaskType.choice: 1,
      },
      taskData: [...shapeData, ...additionDigitsData],
      help: 'Розпізнавання геометричних фігур.',
      evaluation: EvaluationConfig(accuracyWeight: 1.0),
    ),
  ];
}
