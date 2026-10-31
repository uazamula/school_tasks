import 'package:flutter/material.dart';

import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_audio_widget.dart';

class MatchingContentWidget extends StatelessWidget {
  const MatchingContentWidget({
    super.key,
    required this.content,
    this.isActive = false,
    this.textStyle,
    this.textScaler,
    this.audioController,
  });

  final TaskContent content;
  final bool isActive;
  final TextStyle? textStyle;
  final TextScaler? textScaler;
  final AudioPlaybackController? audioController;

  @override
  Widget build(BuildContext context) {
    final base = _buildBase(context);
    final audio = content.audio;

    if (audio == null) return base;

    return TaskAudioWidget(
      content: audio,
      isActive: false,
      interactive: false,
      showIcon: false,
      controller: audioController,
      child: base,
    );
  }

  Widget _buildBase(BuildContext context) {
    if (content is TextContent) {
      return Text(
        (content as TextContent).text,
        textAlign: TextAlign.center,
        softWrap: true,
        style: textStyle ?? const TextStyle(fontSize: 20),
        textScaler: textScaler,
      );
    }

    if (content is EmojiContent) {
      return Text(
        (content as EmojiContent).emoji,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 80),
      );
    }

    if (content is ImageContent) {
      return SizedBox(
        width: 120,
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
        controller: audioController,
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
          return MatchingContentWidget(
            content: grid.item,
            textStyle: textStyle,
            textScaler: textScaler,
            audioController: audioController,
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}
