import 'learning_node_type.dart';

class LearningNode {
  final String id;
  final String titleKey;
  final LearningNodeType type;
  final List<LearningNode> children;

  const LearningNode({
    required this.id,
    required this.titleKey,
    required this.type,
    this.children = const [],
  });

  bool get hasChildren => children.isNotEmpty;

  bool get isKnowledgeLevel => type == LearningNodeType.knowledgeLevel;

  bool get isSection => type == LearningNodeType.section;

  bool get isTopic => type == LearningNodeType.topic;
}
