import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/data/learning_content.dart';
import 'package:school_tasks/features/learning/domain/learning_node.dart';
import 'package:school_tasks/features/learning/domain/topic_attempt_result.dart';
import 'package:school_tasks/features/learning/presentation/dialogs/topic_dialog.dart';
import 'package:school_tasks/features/learning/presentation/widgets/learning_node_widget.dart';

import '../../../core/widgets/app_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, TopicAttemptResult> _topicResults = {};

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ListView(
        children: LearningContent.items.map((node) {
          return LearningNodeWidget(
            node: node,
            getTopicResult: (topicId) => _topicResults[topicId],
            onTopicPressed: _onTopicPressed,
          );
        }).toList(),
      ),
    );
  }

  Future<void> _onTopicPressed(LearningNode topicNode) async {
    final topic = LearningContent.topics.firstWhere(
      (topic) => topic.id == topicNode.id,
    );

    final result = await showDialog<TopicAttemptResult>(
      context: context,
      builder: (_) {
        return TopicDialog(
          topicNode: topicNode,
          topic: topic,
          result: _topicResults[topicNode.id],
        );
      },
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _topicResults[topicNode.id] = result;
    });
  }
}
