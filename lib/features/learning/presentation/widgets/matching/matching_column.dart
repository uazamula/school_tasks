import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/presentation/widgets/matching/matching_item_widget.dart';

class MatchingColumn extends StatelessWidget {
  const MatchingColumn({
    super.key,
    required this.pairs,
    required this.order,
    required this.completedPairIndices,
    required this.selectedIndex,
    required this.isLeft,
    required this.onItemTap,
  });

  final List<MatchingPair> pairs;
  final List<int> order;
  final Set<int> completedPairIndices;
  final int? selectedIndex;
  final bool isLeft;
  final ValueChanged<int> onItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final index in order)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Visibility(
              visible: !completedPairIndices.contains(index),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: MatchingItemWidget(
                content: isLeft ? pairs[index].left : pairs[index].right,
                isSelected: selectedIndex == index,
                onTap: () => onItemTap(index),
              ),
            ),
          ),
      ],
    );
  }
}
