import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/target_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_prompt/prompt_content_builder.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_prompt/prompt_target_view.dart';

/// Умова завдання: розкладка контенту й цілі.
/// Побудову самих елементів виконують [PromptContentBuilder]
/// та [PromptTargetView].
class TaskPromptWidget extends StatelessWidget {
  const TaskPromptWidget({
    super.key,
    required this.prompt,
    this.scrollable = false,
    this.targetProgress = 0,
    this.targetTotal,
  });

  /// Загальна кількість слотів для складання. null — невідома наперед
  /// (тоді для ефекту без явних steps використовується 1 крок).
  final int? targetTotal;
  static const PromptContentBuilder _content = PromptContentBuilder();

  /// Висота цілі в нескролованій розкладці.
  static const double _targetHeight = 120;

  final TaskPrompt prompt;
  final bool scrollable;

  /// Кількість правильно заповнених слотів.
  final int targetProgress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: colorScheme.onSurfaceVariant,
    );

    if (scrollable) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _content.buildColumn(context, prompt.content, textStyle),
          if (prompt.target != null) ...[
            const SizedBox(height: AppSpacing.md),
            _buildTarget(prompt.target!, textStyle),
          ],
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        final firstVisualIndex = prompt.content.indexWhere(
          PromptContentBuilder.isVisual,
        );

        // Увесь prompt є невізуальним.
        if (firstVisualIndex == -1) {
          return SizedBox(
            width: maxWidth,
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: maxWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _content.buildColumn(context, prompt.content, textStyle),
                    if (prompt.target != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      _buildSizedTarget(prompt.target!, textStyle, maxWidth),
                    ],
                  ],
                ),
              ),
            ),
          );
        }

        final nonVisualContent = prompt.content.sublist(0, firstVisualIndex);
        final scalableContent = prompt.content.sublist(firstVisualIndex);

        return SizedBox(
          width: maxWidth,
          child: Column(
            children: [
              if (nonVisualContent.isNotEmpty) ...[
                _content.buildColumn(context, nonVisualContent, textStyle),
                const SizedBox(height: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _content.buildScalable(
                        context,
                        scalableContent,
                        textStyle,
                      ),
                    ),
                    if (prompt.target != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      _buildSizedTarget(prompt.target!, textStyle, maxWidth),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTarget(TargetContent target, TextStyle? textStyle) {
    return PromptTargetView(
      target: target,
      totalSlots: targetTotal,
      targetProgress: targetProgress,
      contentBuilder: _content,
      textStyle: textStyle,
    );
  }

  Widget _buildSizedTarget(
    TargetContent target,
    TextStyle? textStyle,
    double maxWidth,
  ) {
    return SizedBox(
      width: maxWidth,
      height: _targetHeight,
      child: _buildTarget(target, textStyle),
    );
  }
}
