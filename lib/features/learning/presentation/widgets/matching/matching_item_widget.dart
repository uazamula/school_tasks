import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_button_config.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/presentation/widgets/matching/matching_content_widget.dart';

class MatchingItemWidget extends StatelessWidget {
  const MatchingItemWidget({
    super.key,
    required this.content,
    required this.isSelected,
    required this.onTap,
    this.buttonConfig,
  });

  final TaskContent content;
  final bool isSelected;
  final VoidCallback onTap;
  final MatchingButtonConfig? buttonConfig;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final width = buttonConfig?.buttonWidth ?? 160;
    final height = buttonConfig?.buttonHeight ?? 72;

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: isSelected ? colorScheme.primaryContainer : colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : Theme.of(context).dividerColor,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: ClipRect(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: width - AppSpacing.sm * 2,
                    child: MatchingContentWidget(
                      content: content,
                      isActive: isSelected,
                      textStyle: TextStyle(
                        fontSize: buttonConfig?.fontSize ?? 20,
                      ),
                      textScaler: buttonConfig?.textScaler,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
