import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final content in prompt.content) ...[
          _buildContent(context, content, textStyle),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    TaskContent content,
    TextStyle? textStyle,
  ) {
    if (content is TextContent) {
      return Text(content.text, style: textStyle, textAlign: TextAlign.center);
    }

    if (content is ImageContent) {
      return Image.asset(content.imagePath, fit: BoxFit.contain);
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
                child: _buildContent(context, content.item, null),
              );
            },
          ),
        );
      },
    );
  }
}
