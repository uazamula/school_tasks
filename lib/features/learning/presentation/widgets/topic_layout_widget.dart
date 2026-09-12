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
    return Column(
      children: [
        Expanded(
          flex: layout.promptFlex,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: prompt),
          ),
        ),

        Expanded(
          flex: layout.interactionFlex,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Center(child: interaction),
          ),
        ),
      ],
    );
  }
}
