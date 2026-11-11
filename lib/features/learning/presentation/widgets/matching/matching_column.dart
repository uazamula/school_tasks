import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_button_config.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/presentation/widgets/matching/matching_item_widget.dart';

class MatchingColumn extends StatelessWidget {
  const MatchingColumn({
    super.key,
    required this.pairs,
    required this.order,
    required this.hiddenIndices,
    required this.selectedIndex,
    required this.isLeft,
    required this.onItemTap,
    this.buttonConfig,
    this.onAudioPlaybackStarted,
  });

  final List<MatchingPair> pairs;
  final List<int> order;

  /// Індекси елементів цієї колонки, які вже складено й приховано.
  /// Для кожної колонки множина своя: ховається саме той елемент,
  /// на який натиснули, навіть якщо є дублікати за значенням.
  final Set<int> hiddenIndices;
  final int? selectedIndex;
  final bool isLeft;
  final ValueChanged<int> onItemTap;
  final MatchingButtonConfig? buttonConfig;
  final ValueChanged<Future<void>?>? onAudioPlaybackStarted;

  /// Ключ елемента колонки (використовується, зокрема, у тестах).
  static ValueKey<String> itemKey({required bool isLeft, required int index}) =>
      ValueKey('matching-${isLeft ? 'left' : 'right'}-$index');

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final index in order)
          Padding(
            padding: EdgeInsets.only(
              bottom: buttonConfig?.spacing ?? AppSpacing.md,
            ),
            child: Visibility(
              key: itemKey(isLeft: isLeft, index: index),
              visible: !hiddenIndices.contains(index),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: MatchingItemWidget(
                content: isLeft ? pairs[index].left : pairs[index].right,
                isSelected: selectedIndex == index,
                onTap: () => onItemTap(index),
                buttonConfig: buttonConfig,
                onAudioPlaybackStarted: onAudioPlaybackStarted,
              ),
            ),
          ),
      ],
    );
  }
}
