import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/topic_attempt_result.dart';
import 'package:school_tasks/features/learning/domain/topic_status.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/learning_node.dart';
import '../../domain/learning_node_type.dart';
import 'topic_status_indicator.dart';

class LearningNodeWidget extends StatelessWidget {
  const LearningNodeWidget({
    super.key,
    required this.node,
    this.level = 0,
    this.onTopicPressed,
    this.getTopicResult,
  });

  final LearningNode node;
  final int level;
  final ValueChanged<LearningNode>? onTopicPressed;
  final TopicAttemptResult? Function(String topicId)? getTopicResult;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: level * AppSpacing.lg,
        bottom: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNode(),

          if (node.hasChildren)
            ...node.children.map(
              (child) => LearningNodeWidget(
                node: child,
                level: level + 1,
                onTopicPressed: onTopicPressed,
                getTopicResult: getTopicResult,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNode() {
    switch (node.type) {
      case LearningNodeType.knowledgeLevel:
        return Text(node.titleKey, style: AppTextStyles.headline);

      case LearningNodeType.section:
        return Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: Text(node.titleKey, style: AppTextStyles.title),
        );

      case LearningNodeType.topic:
        return InkWell(
          onTap: () => onTopicPressed?.call(node),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                TopicStatusIndicator(status: _getTopicStatus()),

                const SizedBox(width: AppSpacing.sm),

                Expanded(child: Text(node.titleKey, style: AppTextStyles.body)),
              ],
            ),
          ),
        );
    }
  }

  TopicStatus _getTopicStatus() {
    return getTopicResult?.call(node.id) == null
        ? TopicStatus.notStarted
        : TopicStatus.completed;
  }

  // TopicAttemptResult? _getTopicResult(LearningNode node) {
  //   if (node.type != LearningNodeType.topic) {
  //     return null;
  //   }
  //
  //   return node.id == node.id ? topicResult : null;
  // }
}
