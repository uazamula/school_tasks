import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:school_tasks/core/preferences/preferences_provider.dart';

part 'learning_tree_controller.g.dart';

@Riverpod(keepAlive: true)
class LearningTreeController extends _$LearningTreeController {
  /// Стан — множина згорнутих вузлів. Порожня множина = усе розгорнуто.
  @override
  Future<Set<String>> build() async {
    final preferences = await ref.watch(appPreferencesProvider.future);

    return preferences.getCollapsedLearningNodeIds();
  }

  Future<void> toggleNode(String nodeId) async {
    final preferences = await ref.read(appPreferencesProvider.future);

    final newIds = {...(state.valueOrNull ?? <String>{})};

    if (!newIds.remove(nodeId)) {
      newIds.add(nodeId);
    }

    await preferences.setCollapsedLearningNodeIds(newIds);

    state = AsyncData(newIds);
  }

  bool isExpanded(String nodeId) {
    return !(state.valueOrNull?.contains(nodeId) ?? false);
  }
}
