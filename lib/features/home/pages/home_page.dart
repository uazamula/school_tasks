import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/data/learning_content.dart';
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
            onTopicPressed: (topic) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(topic.titleKey)));
            },
          );
        }).toList(),
      ),
    );
  }
}
