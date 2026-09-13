import 'package:flutter/material.dart';

import 'package:school_tasks/features/learning/domain/topic_layout.dart';

class TopicLayoutWidget extends StatelessWidget {
  const TopicLayoutWidget({
    super.key,
    required this.layout,
    required this.prompt,
    required this.interaction,
  });

  final TopicLayout layout;
  final Widget prompt;
  final Widget interaction;

  @override
  Widget build(BuildContext context) {
    final bool scrollablePrompt = layout.prompt.scrollable;
    final bool scrollableInteraction = layout.interaction.scrollable;

    return Column(
      children: [
        Expanded(
          flex: layout.promptFlex,
          child: _buildArea(
            child: prompt,
            scrollable: scrollablePrompt,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
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
    );
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
