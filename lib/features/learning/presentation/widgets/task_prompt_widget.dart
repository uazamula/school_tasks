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

    if (content is GeneratedGridContent) {
      return _buildGrid(content);
    }

    return const SizedBox.shrink();
  }

  Widget _buildGrid(GeneratedGridContent content) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = MediaQuery.sizeOf(context);

        final maxHeight = screenSize.height * 0.33;
        final maxWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : screenSize.width;

        final cellSize = min(
          maxWidth / content.columns,
          maxHeight / content.rows,
        );

        final width = cellSize * content.columns;
        final height = cellSize * content.rows;

        return SizedBox(
          width: width,
          height: height,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: content.columns,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
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
