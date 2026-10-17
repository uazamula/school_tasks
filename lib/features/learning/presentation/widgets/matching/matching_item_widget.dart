import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_button_config.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_linked_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/presentation/widgets/matching/matching_content_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_audio_widget.dart';

class MatchingItemWidget extends StatefulWidget {
  const MatchingItemWidget({
    super.key,
    required this.content,
    required this.isSelected,
    required this.onTap,
    this.buttonConfig,
    this.onAudioPlaybackStarted,
  });

  final TaskContent content;
  final bool isSelected;
  final VoidCallback onTap;
  final MatchingButtonConfig? buttonConfig;
  final ValueChanged<Future<void>?>? onAudioPlaybackStarted;

  @override
  State<MatchingItemWidget> createState() => _MatchingItemWidgetState();
}

class _MatchingItemWidgetState extends State<MatchingItemWidget> {
  late final AudioPlaybackController _audioController;

  @override
  void initState() {
    super.initState();
    _audioController = AudioPlaybackController();
  }

  @override
  void dispose() {
    _audioController.dispose();
    super.dispose();
  }

  void _handleTap() {
    Future<void>? playback;

    if (widget.content is AudioLinkedContent) {
      playback = _audioController.playAndWait();
    }

    widget.onAudioPlaybackStarted?.call(playback);

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final width = widget.buttonConfig?.buttonWidth ?? 160;
    final height = widget.buttonConfig?.buttonHeight ?? 72;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? widget.buttonConfig?.darkBackgroundColor
        : widget.buttonConfig?.lightBackgroundColor;

    final isAudioLinked = widget.content is AudioLinkedContent;

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: widget.isSelected
            ? colorScheme.primaryContainer
            : backgroundColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.isSelected
                    ? colorScheme.primary
                    : Theme.of(context).dividerColor,
                width: widget.isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: ClipRect(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: width - AppSpacing.sm * 2,
                    child: MatchingContentWidget(
                      content: widget.content,
                      isActive: widget.isSelected,
                      textStyle: TextStyle(
                        fontSize: widget.buttonConfig?.fontSize ?? 20,
                      ),
                      textScaler: widget.buttonConfig?.textScaler,
                      audioController: isAudioLinked ? _audioController : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
