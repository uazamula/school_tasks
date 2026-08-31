import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/core/theme/app_text_styles.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';

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

    return const SizedBox.shrink();
  }
}
