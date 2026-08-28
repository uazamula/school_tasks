import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/preferences/preferences_provider.dart';
import 'package:school_tasks/features/learning/data/learning_content.dart';
import 'package:school_tasks/features/learning/domain/learning_node.dart';
import 'package:school_tasks/features/learning/domain/topic_attempt_result.dart';
import 'package:school_tasks/features/learning/domain/topic_result_updater.dart';
import 'package:school_tasks/features/learning/presentation/dialogs/topic_dialog.dart';
import 'package:school_tasks/features/learning/presentation/widgets/learning_node_widget.dart';
import 'package:school_tasks/features/learning/providers/learning_results_controller.dart';

import '../../../core/widgets/app_scaffold.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _topicResultUpdater = const TopicResultUpdater();

  @override
  void initState() {
    super.initState();
    _loadTopicResults();
  }

  Future<void> _loadTopicResults() async {
    final preferences = await ref.read(appPreferencesProvider.future);
    final controller = ref.read(learningResultsControllerProvider.notifier);

    for (final topic in LearningContent.topics) {
      final result = preferences.getTopicResult(topic.id);

      if (result != null) {
        controller.setResult(topic.id, result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topicResults = ref.watch(learningResultsControllerProvider);

    return AppScaffold(
      child: ListView(
        children: LearningContent.items.map((node) {
          return LearningNodeWidget(
            node: node,
            getTopicResult: (topicId) => topicResults[topicId],
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

    final topicResults = ref.read(learningResultsControllerProvider);

    final attemptResult = await showDialog<TopicAttemptResult>(
      context: context,
      builder: (_) {
        return TopicDialog(
          topicNode: topicNode,
          topic: topic,
          result: topicResults[topicNode.id],
          onResetResult: () {
            _resetTopicResult(topicNode.id);
          },
        );
      },
    );

    if (attemptResult == null || !mounted) {
      return;
    }

    final previousResult = ref.read(
      learningResultsControllerProvider,
    )[topicNode.id];

    final topicResult = _topicResultUpdater.update(
      attempt: attemptResult,
      currentAt: DateTime.now(),
      previous: previousResult,
    );

    final preferences = await ref.read(appPreferencesProvider.future);

    await preferences.setTopicResult(topicNode.id, topicResult);

    if (!mounted) {
      return;
    }

    ref
        .read(learningResultsControllerProvider.notifier)
        .setResult(topicNode.id, topicResult);
  }

  Future<void> _resetTopicResult(String topicId) async {
    final preferences = await ref.read(appPreferencesProvider.future);

    await preferences.clearTopicResult(topicId);

    if (!mounted) {
      return;
    }

    ref.read(learningResultsControllerProvider.notifier).removeResult(topicId);
  }
}
