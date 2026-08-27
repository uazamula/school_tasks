import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/preferences/preferences_provider.dart';
import 'package:school_tasks/features/learning/data/learning_content.dart';
import 'package:school_tasks/features/learning/domain/learning_node.dart';
import 'package:school_tasks/features/learning/domain/topic_attempt_result.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';
import 'package:school_tasks/features/learning/domain/topic_result_updater.dart';
import 'package:school_tasks/features/learning/presentation/dialogs/topic_dialog.dart';
import 'package:school_tasks/features/learning/presentation/widgets/learning_node_widget.dart';

import '../../../core/widgets/app_scaffold.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final Map<String, TopicResult> _topicResults = {};

  final _topicResultUpdater = const TopicResultUpdater();

  @override
  void initState() {
    super.initState();
    _loadTopicResults();
  }

  Future<void> _loadTopicResults() async {
    final preferences = await ref.read(appPreferencesProvider.future);

    final results = <String, TopicResult>{};

    for (final topic in LearningContent.topics) {
      final result = preferences.getTopicResult(topic.id);

      if (result != null) {
        results[topic.id] = result;
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _topicResults
        ..clear()
        ..addAll(results);
    });
  }

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

    final attemptResult = await showDialog<TopicAttemptResult>(
      context: context,
      builder: (_) {
        return TopicDialog(
          topicNode: topicNode,
          topic: topic,
          result: _topicResults[topicNode.id],
          onResetResult: () {
            _resetTopicResult(topicNode.id);
          },
        );
      },
    );

    if (attemptResult == null || !mounted) {
      return;
    }

    final topicResult = _topicResultUpdater.update(
      attempt: attemptResult,
      currentAt: DateTime.now(),
      previous: _topicResults[topicNode.id],
    );

    final preferences = await ref.read(appPreferencesProvider.future);

    await preferences.setTopicResult(topicNode.id, topicResult);

    if (!mounted) {
      return;
    }

    setState(() {
      _topicResults[topicNode.id] = topicResult;
    });
  }

  Future<void> _resetTopicResult(String topicId) async {
    final preferences = await ref.read(appPreferencesProvider.future);

    await preferences.clearTopicResult(topicId);

    if (!mounted) {
      return;
    }

    setState(() {
      _topicResults.remove(topicId);
    });
  }
}
