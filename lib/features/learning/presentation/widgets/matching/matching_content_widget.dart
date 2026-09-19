import 'package:flutter/material.dart';

import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_audio_widget.dart';

class MatchingContentWidget extends StatelessWidget {
  const MatchingContentWidget({
    super.key,
    required this.content,
    this.isActive = false,
  });
  final TaskContent content;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    if (content is TextContent) {
      return Text(
        (content as TextContent).text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
      );
    }

    if (content is EmojiContent) {
      return Text(
        (content as EmojiContent).emoji,
        style: const TextStyle(fontSize: 40),
      );
    }

    if (content is ImageContent) {
      return SizedBox(
        width: 80,
        height: 80,
        child: Image.asset(
          (content as ImageContent).imagePath,
          fit: BoxFit.contain,
        ),
      );
    }

    if (content is AudioContent) {
      return TaskAudioWidget(
        content: content as AudioContent,
        isActive: isActive,
        interactive: false,
      );
    }

    if (content is GridContent) {
      final grid = content as GridContent;

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: grid.columns,
        ),
        itemCount: grid.rows * grid.columns,
        itemBuilder: (context, index) {
          return MatchingContentWidget(content: grid.item);
        },
      );
    }

    return const SizedBox.shrink();
  }
}
