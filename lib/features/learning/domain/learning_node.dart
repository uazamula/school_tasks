import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'learning_node_type.dart';

class LearningNode {
  final String id;
  final String titleKey;
  final LearningNodeType type;
  final List<LearningNode> children;

  /// Назва теми у вигляді елементів зліва направо (буква, зображення,
  /// емодзі). Якщо порожній, плитка показує [titleKey] текстом.
  final List<TaskContent> titleContent;

  const LearningNode({
    required this.id,
    required this.titleKey,
    required this.type,
    this.children = const [],
    this.titleContent = const [],
  });

  bool get hasChildren => children.isNotEmpty;

  bool get isKnowledgeLevel => type == LearningNodeType.knowledgeLevel;

  bool get isSection => type == LearningNodeType.section;

  bool get isTopic => type == LearningNodeType.topic;
}
