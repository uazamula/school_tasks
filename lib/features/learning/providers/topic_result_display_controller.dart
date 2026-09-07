import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:school_tasks/core/preferences/preferences_provider.dart';
import 'package:school_tasks/features/learning/domain/evaluation/topic_result_display.dart';

part 'topic_result_display_controller.g.dart';

@Riverpod(keepAlive: true)
class TopicResultDisplayController extends _$TopicResultDisplayController {
  @override
  Future<TopicResultDisplay> build() async {
    final preferences = await ref.watch(appPreferencesProvider.future);

    return preferences.getTopicResultDisplay();
  }

  Future<void> setTopicResultDisplay(TopicResultDisplay display) async {
    final preferences = await ref.read(appPreferencesProvider.future);

    await preferences.setTopicResultDisplay(display);

    state = AsyncData(display);
  }
}
