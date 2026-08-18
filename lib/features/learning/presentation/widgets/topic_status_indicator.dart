import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/topic_status.dart';

class TopicStatusIndicator extends StatelessWidget {
  const TopicStatusIndicator({super.key, required this.status});

  final TopicStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case TopicStatus.notStarted:
        return const Icon(Icons.circle_outlined, size: 20);

      case TopicStatus.completed:
        return const Icon(Icons.check_circle, size: 20);
    }
  }
}
