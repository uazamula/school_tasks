import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/data/learning_content.dart';
import 'package:school_tasks/features/learning/domain/topic_attempt_result.dart';
import 'package:school_tasks/features/learning/presentation/dialogs/topic_dialog.dart';
import 'package:school_tasks/features/learning/presentation/widgets/learning_node_widget.dart';

import '../../../core/widgets/app_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ListView(
        children: LearningContent.items.map((node) {
          return LearningNodeWidget(
            node: node,
            onTopicPressed: (topic) async {
              final result = await showDialog<TopicAttemptResult>(
                context: context,
                builder: (_) {
                  return TopicDialog(topic: topic);
                },
              );

              if (result != null) {
                debugPrint(
                  'HomePage received: '
                  '${result.correctTasks}/${result.totalTasks}',
                );
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
