import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/math_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/presentation/widgets/math_content_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_audio_widget.dart';

typedef ImageContentBuilder = Widget Function(ImageContent content);

/// Перетворює [TaskContent] умови завдання на віджети.
class PromptContentBuilder {
  const PromptContentBuilder();

  /// Візуальний контент масштабується разом із доступним простором.
  static bool isVisual(TaskContent content) {
    return content is ImageContent ||
        content is GridContent ||
        content is EmojiContent;
  }

  /// Контент один під одним на всю ширину (для нескролованого
  /// невізуального та скролованого вмісту).
  Widget buildColumn(
    BuildContext context,
    List<TaskContent> content,
    TextStyle? textStyle,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final item in content) ...[
          build(context, item, textStyle, fullWidthText: true),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }

  /// Контент, що масштабується під доступний простір.
  Widget buildScalable(
    BuildContext context,
    List<TaskContent> content,
    TextStyle? textStyle,
  ) {
    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final item in content) ...[
              build(context, item, textStyle, fullWidthText: false),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }

  /// Один елемент контенту; якщо до нього привʼязане аудіо — натискання
  /// на елемент відтворює його.
  Widget build(
    BuildContext context,
    TaskContent content,
    TextStyle? textStyle, {
    bool fullWidthText = false,
    ImageContentBuilder? imageBuilder,
  }) {
    final built = _buildBase(
      context,
      content,
      textStyle,
      fullWidthText: fullWidthText,
      imageBuilder: imageBuilder,
    );

    final audio = content.audio;
    if (audio == null) return built;

    return TaskAudioWidget(
      content: audio,
      interactive: true,
      showIcon: false,
      child: built,
    );
  }

  Widget _buildBase(
    BuildContext context,
    TaskContent content,
    TextStyle? textStyle, {
    ImageContentBuilder? imageBuilder,
    bool fullWidthText = false,
  }) {
    if (content is TextContent) {
      final text = Text(
        content.text,
        style: textStyle,
        textAlign: TextAlign.center,
        softWrap: true,
      );

      if (fullWidthText) {
        return SizedBox(width: double.infinity, child: text);
      }

      return text;
    }

    if (content is AudioContent) {
      return TaskAudioWidget(content: content);
    }

    if (content is ImageContent) {
      if (imageBuilder != null) return imageBuilder(content);
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        child: Image.asset(content.imagePath, fit: BoxFit.contain),
      );
    }

    if (content is MathContent) {
      return MathContentWidget(
        expression: content.expression,
        style: textStyle,
      );
    }

    if (content is GridContent) {
      return _buildGrid(content);
    }

    if (content is EmojiContent) {
      return Text(
        content.emoji,
        textAlign: TextAlign.center,
        style: textStyle?.copyWith(fontSize: 64),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildGrid(GridContent content) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        const spacing = AppSpacing.md;

        final horizontalSpacing = spacing * (content.columns - 1);

        final availableWidth = maxWidth - horizontalSpacing;

        if (availableWidth <= 0) {
          return const SizedBox.shrink();
        }

        final cellSize = availableWidth / content.columns;

        final width = cellSize * content.columns + horizontalSpacing;

        final height = cellSize * content.rows + spacing * (content.rows - 1);

        return SizedBox(
          width: width,
          height: height,
          child: GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: content.columns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: 1,
            ),
            itemCount: content.rows * content.columns,
            itemBuilder: (context, index) {
              return SizedBox(
                width: cellSize,
                height: cellSize,
                child: build(context, content.item, null),
              );
            },
          ),
        );
      },
    );
  }
}
