import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:school_tasks/core/preferences/preferences_provider.dart';

part 'learning_tree_controller.g.dart';

@Riverpod(keepAlive: true)
class LearningTreeController extends _$LearningTreeController {
  bool _hasStoredState = false;

  @override
  Future<Set<String>> build() async {
    final preferences = await ref.watch(appPreferencesProvider.future);

    _hasStoredState = preferences.hasExpandedLearningNodeIds();

    if (!_hasStoredState) {
      return {};
    }

    return preferences.getExpandedLearningNodeIds();
  }

  Future<void> toggleNode(String nodeId) async {
    final preferences = await ref.read(appPreferencesProvider.future);

    final currentIds = state.valueOrNull ?? {};
    final newIds = {...currentIds};

    if (newIds.contains(nodeId)) {
      newIds.remove(nodeId);
    } else {
      newIds.add(nodeId);
    }

    await preferences.setExpandedLearningNodeIds(newIds);

    _hasStoredState = true;
    state = AsyncData(newIds);
  }

  bool isExpanded(String nodeId) {
    if (!_hasStoredState) {
      return true;
    }

    return state.valueOrNull?.contains(nodeId) ?? false;
  }
}
