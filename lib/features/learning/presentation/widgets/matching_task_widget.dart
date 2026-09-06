import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_answer.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/matching_task.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_prompt_widget.dart';

class MatchingTaskWidget extends StatelessWidget {
  const MatchingTaskWidget({
    super.key,
    required this.task,
    required this.result,
    required this.onTaskAnswered,
  });

  final MatchingTask task;
  final TaskResult<MatchingAnswer, dynamic>? result;
  final ValueChanged<TaskResult<MatchingAnswer, dynamic>> onTaskAnswered;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TaskPromptWidget(prompt: task.prompt),
        const SizedBox(height: AppSpacing.xl),
        Text('Відібрано пар: ${task.pairs.length}'),
        const SizedBox(height: AppSpacing.lg),
        for (final pair in task.pairs) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildContent(pair.left),
              const SizedBox(width: AppSpacing.md),
              const Text('↔'),
              const SizedBox(width: AppSpacing.md),
              _buildContent(pair.right),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }

  Widget _buildContent(TaskContent content) {
    if (content is TextContent) {
      return Text(content.text);
    }

    if (content is EmojiContent) {
      return Text(content.emoji, style: const TextStyle(fontSize: 40));
    }

    if (content is ImageContent) {
      return SizedBox(
        width: 80,
        height: 80,
        child: Image.asset(content.imagePath, fit: BoxFit.contain),
      );
    }

    return const SizedBox.shrink();
  }
}
