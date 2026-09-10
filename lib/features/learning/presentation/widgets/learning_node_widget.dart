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

  static const double _topicResultWidth = 56;
  static const double _topicCardHeight = 64;
  static const double _topicCardRadius = 8;

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
          _buildNode(context, expanded),

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

  Widget _buildNode(BuildContext context, bool expanded) {
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
        return _buildTopicCard(context);
    }
  }

  Widget _buildTopicCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_topicCardRadius),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onTopicPressed?.call(node),
        child: SizedBox(
          height: _topicCardHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              children: [
                SizedBox(
                  width: _topicResultWidth,
                  child: Center(
                    child: TopicResultIndicator(
                      result: getTopicResult?.call(node.id),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _buildTopicTitle()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopicTitle() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Text(node.titleKey, style: AppTextStyles.body),
    );
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
