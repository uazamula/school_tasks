import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_audio_widget.dart';

class TaskPromptWidget extends StatelessWidget {
  const TaskPromptWidget({super.key, required this.prompt});

  final TaskPrompt prompt;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.normal,
      color: colorScheme.onSurfaceVariant,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        final firstVisualIndex = prompt.content.indexWhere(_isVisual);

        // Увесь prompt є невізуальним.
        if (firstVisualIndex == -1) {
          return SizedBox(
            width: maxWidth,
            child: _buildNonVisualContent(
              context,
              prompt.content,
              textStyle,
            ),
          );
        }

        final nonVisualContent = prompt.content.sublist(0, firstVisualIndex);
        final scalableContent = prompt.content.sublist(firstVisualIndex);

        return SizedBox(
          width: maxWidth,
          child: Column(
            children: [
              if (nonVisualContent.isNotEmpty)
                _buildNonVisualContent(
                  context,
                  nonVisualContent,
                  textStyle,
                ),

              if (nonVisualContent.isNotEmpty)
                const SizedBox(height: AppSpacing.md),

              Expanded(
                child: _buildScalableContent(
                  context,
                  scalableContent,
                  textStyle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isVisual(TaskContent content) {
    return content is ImageContent || content is GridContent;
  }

  Widget _buildNonVisualContent(
      BuildContext context,
      List<TaskContent> content,
      TextStyle? textStyle,
      ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final item in content) ...[
          _buildContent(
            context,
            item,
            textStyle,
            fullWidthText: true,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }

  Widget _buildScalableContent(
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
              _buildContent(
                context,
                item,
                textStyle,
                fullWidthText: false,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      TaskContent content,
      TextStyle? textStyle, {
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
        return SizedBox(
          width: double.infinity,
          child: text,
        );
      }

      return text;
    }

    if (content is AudioContent) {
      return TaskAudioWidget(content: content);
    }

    if (content is ImageContent) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        child: Image.asset(
          content.imagePath,
          fit: BoxFit.contain,
        ),
      );
    }

    if (content is GridContent) {
      return _buildGrid(content);
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

        final height =
            cellSize * content.rows +
                spacing * (content.rows - 1);

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
                child: _buildContent(
                  context,
                  content.item,
                  null,
                ),
              );
            },
          ),
        );
      },
    );
  }
}