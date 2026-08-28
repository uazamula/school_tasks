import 'package:school_tasks/features/learning/data/topics/topic_addition_digits.dart';
import 'package:school_tasks/features/learning/data/topics/topic_addition_within_10.dart';
import 'package:school_tasks/features/learning/data/topics/topic_shapes.dart';
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
          id: 'test_section',
          titleKey: 'testSection',
          type: LearningNodeType.section,
        ),
      ],
    ),
  ];

  static const List<Topic> topics = [
    AdditionDigits.topic,
    AdditionWithin10.topic,
    Shapes.topic,
  ];

  static Topic getTopic(String topicId) {
    return topics.firstWhere((topic) => topic.id == topicId);
  }
}
