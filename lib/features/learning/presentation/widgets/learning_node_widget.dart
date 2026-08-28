import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/learning_node.dart';
import '../../domain/learning_node_type.dart';
import 'topic_result_indicator.dart';

class LearningNodeWidget extends StatefulWidget {
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
  final TopicResult? Function(String topicId)? getTopicResult;

  @override
  State<LearningNodeWidget> createState() => _LearningNodeWidgetState();
}

class _LearningNodeWidgetState extends State<LearningNodeWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.level * AppSpacing.lg,
        bottom: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNode(),

          if (widget.node.hasChildren && _isExpanded)
            ...widget.node.children.map(
              (child) => LearningNodeWidget(
                node: child,
                level: widget.level + 1,
                onTopicPressed: widget.onTopicPressed,
                getTopicResult: widget.getTopicResult,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNode() {
    switch (widget.node.type) {
      case LearningNodeType.knowledgeLevel:
        return _buildExpandableNode(
          child: Text(widget.node.titleKey, style: AppTextStyles.headline),
        );

      case LearningNodeType.section:
        return _buildExpandableNode(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(widget.node.titleKey, style: AppTextStyles.title),
          ),
        );

      case LearningNodeType.topic:
        return InkWell(
          onTap: () => widget.onTopicPressed?.call(widget.node),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                TopicResultIndicator(
                  result: widget.getTopicResult?.call(widget.node.id),
                ),

                const SizedBox(width: AppSpacing.sm),

                Expanded(
                  child: Text(widget.node.titleKey, style: AppTextStyles.body),
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildExpandableNode({required Widget child}) {
    if (!widget.node.hasChildren) {
      return child;
    }

    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isExpanded
                ? Icons.keyboard_arrow_down
                : Icons.keyboard_arrow_right,
          ),

          const SizedBox(width: AppSpacing.xs),

          child,
        ],
      ),
    );
  }
}
