import 'package:school_tasks/features/learning/data/topics/topic_addition_digits.dart';
import 'package:school_tasks/features/learning/data/topics/topic_addition_within_10.dart';
import 'package:school_tasks/features/learning/data/topics/topic_multiplication_table.dart';
import 'package:school_tasks/features/learning/data/topics/topic_test.dart';
import 'package:school_tasks/features/learning/domain/learning_node.dart';
import 'package:school_tasks/features/learning/domain/learning_node_type.dart';
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
        LearningNode(
          id: 'geometry',
          titleKey: 'geometry',
          type: LearningNodeType.section,
          children: [
            LearningNode(
              id: 'shapes',
              titleKey: 'shape',
              type: LearningNodeType.topic,
            ),
          ],
        ),
        LearningNode(
          id: 'multiplication',
          titleKey: 'Множення',
          type: LearningNodeType.section,
          children: [
            LearningNode(
              id: 'multiplication_table',
              titleKey: 'Таблиця множення',
              type: LearningNodeType.topic,
            ),
          ],
        ),
        LearningNode(
          id: 'test_section',
          titleKey: 'testSection',
          type: LearningNodeType.section,
        ),
      ],
    ),
  ];

  static final Map<String, Topic> topics = {
    'addition_digits': AdditionDigits.topic,
    'addition_within_10': AdditionWithin10.topic,
    'shapes': Tests.topic,
    'multiplication_table': MultiplicationTable.topic,
  };

  static Topic getTopic(String topicId) {
    return topics[topicId]!;
  }
}
