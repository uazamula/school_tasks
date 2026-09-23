import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:school_tasks/core/preferences/preferences_provider.dart';
import 'package:school_tasks/features/learning/data/learning_content.dart';
import 'package:school_tasks/features/learning/domain/learning_node.dart';
import 'package:school_tasks/features/learning/presentation/dialogs/topic_dialog.dart';
import 'package:school_tasks/features/learning/presentation/widgets/learning_node_widget.dart';
import 'package:school_tasks/features/learning/providers/learning_results_controller.dart';
import 'package:school_tasks/features/learning/providers/learning_tree_controller.dart';
import 'package:school_tasks/routing/app_routes.dart';

import '../../../core/widgets/app_scaffold.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadTopicResults();
  }

  Future<void> _loadTopicResults() async {
    final preferences = await ref.read(appPreferencesProvider.future);
    final controller = ref.read(learningResultsControllerProvider.notifier);

    for (final topic in LearningContent.topics.values) {
      final result = preferences.getTopicResult(topic.id);

      if (result != null) {
        controller.setResult(topic.id, result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topicResults = ref.watch(learningResultsControllerProvider);

    final treeState = ref.watch(learningTreeControllerProvider);

    return AppScaffold(
      child: treeState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          return Center(child: Text('Помилка завантаження дерева: $error'));
        },
        data: (_) {
          return ListView(
            children: LearningContent.items.map((node) {
              return LearningNodeWidget(
                node: node,
                getTopicResult: (topicId) => topicResults[topicId],
                onTopicPressed: _onTopicPressed,
                isNodeExpanded: (nodeId) {
                  return ref
                      .read(learningTreeControllerProvider.notifier)
                      .isExpanded(nodeId);
                },
                onExpansionChanged: (nodeId) {
                  ref
                      .read(learningTreeControllerProvider.notifier)
                      .toggleNode(nodeId);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<void> _onTopicPressed(LearningNode topicNode) async {
    final topic = LearningContent.topics[topicNode.id]!;

    final topicResults = ref.read(learningResultsControllerProvider);

    final shouldStart = await showDialog<bool>(
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

    if (shouldStart != true || !mounted) {
      return;
    }

    await context.push(AppRoutes.learningFor(topicNode.id));
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
