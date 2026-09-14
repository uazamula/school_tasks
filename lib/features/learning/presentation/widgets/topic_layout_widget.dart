import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/topic_layout.dart';

class TopicLayoutWidget extends StatelessWidget {
  const TopicLayoutWidget({
    super.key,
    required this.layout,
    required this.prompt,
    required this.interaction,
    this.promptOverlay,
    this.dimmed = false,
  });

  final TopicLayout layout;
  final Widget prompt;
  final Widget interaction;
  final Widget? promptOverlay;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final bool scrollablePrompt = layout.prompt.scrollable;
    final bool scrollableInteraction = layout.interaction.scrollable;
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: layout.promptFlex,
              child: _buildPromptArea(scrollable: scrollablePrompt),
            ),
            Expanded(
              flex: layout.interactionFlex,
              child: _buildArea(
                child: interaction,
                scrollable: scrollableInteraction,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              ),
            ),
          ],
        ),
        if (dimmed)
          const Positioned.fill(
            child: IgnorePointer(
              child: ColoredBox(color: Color.fromRGBO(0, 0, 0, 0.30)),
            ),
          ),
        if (dimmed && promptOverlay != null) _buildPromptOverlay(),
      ],
    );
  }

  Widget _buildPromptArea({required bool scrollable}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildArea(
          child: prompt,
          scrollable: scrollable,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        if (!dimmed && promptOverlay != null) promptOverlay!,
      ],
    );
  }

  Widget _buildPromptOverlay() {
    return Positioned.fill(child: Center(child: promptOverlay!));
  }

  Widget _buildArea({
    required Widget child,
    required bool scrollable,
    required EdgeInsets padding,
  }) {
    if (scrollable) {
      return Center(
        child: SingleChildScrollView(padding: padding, child: child),
      );
    }
    return Padding(
      padding: padding,
      child: Center(
        child: FittedBox(fit: BoxFit.contain, child: child),
      ),
    );
  }
}
