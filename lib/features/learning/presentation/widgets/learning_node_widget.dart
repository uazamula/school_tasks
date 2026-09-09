import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/learning_node.dart';
import '../../domain/learning_node_type.dart';
import 'topic_result_indicator.dart';

class LearningNodeWidget extends StatelessWidget {
  const LearningNodeWidget({
    super.key,
    required this.node,
    this.level = 0,
    this.onTopicPressed,
    this.getTopicResult,
    this.isNodeExpanded,
    this.onExpansionChanged,
  });

  final LearningNode node;
  final int level;
  final ValueChanged<LearningNode>? onTopicPressed;
  final TopicResult? Function(String topicId)? getTopicResult;

  final bool Function(String nodeId)? isNodeExpanded;
  final ValueChanged<String>? onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    final expanded = isNodeExpanded?.call(node.id) ?? true;

    return Padding(
      padding: EdgeInsets.only(
        left: level * AppSpacing.lg,
        bottom: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNode(expanded),

          if (node.hasChildren && expanded)
            ...node.children.map(
              (child) => LearningNodeWidget(
                node: child,
                level: level + 1,
                onTopicPressed: onTopicPressed,
                getTopicResult: getTopicResult,
                isNodeExpanded: isNodeExpanded,
                onExpansionChanged: onExpansionChanged,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNode(bool expanded) {
    switch (node.type) {
      case LearningNodeType.knowledgeLevel:
        return _buildExpandableNode(
          expanded: expanded,
          child: Text(node.titleKey, style: AppTextStyles.headline),
        );

      case LearningNodeType.section:
        return _buildExpandableNode(
          expanded: expanded,
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(node.titleKey, style: AppTextStyles.title),
          ),
        );

      case LearningNodeType.topic:
        return InkWell(
          onTap: () => onTopicPressed?.call(node),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                TopicResultIndicator(result: getTopicResult?.call(node.id)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(node.titleKey, style: AppTextStyles.body)),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildExpandableNode({required bool expanded, required Widget child}) {
    if (!node.hasChildren) {
      return child;
    }

    return InkWell(
      onTap: () => onExpansionChanged?.call(node.id),
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
          ),
          const SizedBox(width: AppSpacing.xs),
          child,
        ],
      ),
    );
  }
}
