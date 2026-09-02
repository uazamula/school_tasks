import 'dart:math';

import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/core/theme/app_text_styles.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

class TaskPromptWidget extends StatelessWidget {
  const TaskPromptWidget({super.key, required this.prompt});

  final TaskPrompt prompt;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final content in prompt.content) ...[
          _buildContent(content),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }

  Widget _buildContent(TaskContent content) {
    if (content is TextContent) {
      return Text(
        content.text,
        style: AppTextStyles.headline,
        textAlign: TextAlign.center,
      );
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
        final screenSize = MediaQuery.sizeOf(context);

        final maxHeight = screenSize.height * 0.33;
        final maxWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : screenSize.width;

        // AppSpacing.sm = 8 px → 50% більше = 12 px.
        final spacing = AppSpacing.sm * 1.5;

        final horizontalSpacing = spacing * (content.columns - 1);

        final verticalSpacing = spacing * (content.rows - 1);

        final cellSize = min(
          (maxWidth - horizontalSpacing) / content.columns,
          (maxHeight - verticalSpacing) / content.rows,
        );

        final width = cellSize * content.columns + horizontalSpacing;

        final height = cellSize * content.rows + verticalSpacing;

        return SizedBox(
          width: width,
          height: height,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: content.columns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
            ),
            itemCount: content.rows * content.columns,
            itemBuilder: (context, index) {
              return _buildContent(content.item);
            },
          ),
        );
      },
    );
  }
}
