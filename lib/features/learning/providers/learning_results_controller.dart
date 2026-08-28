import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';

part 'learning_results_controller.g.dart';

@Riverpod(keepAlive: true)
class LearningResultsController extends _$LearningResultsController {
  @override
  Map<String, TopicResult> build() {
    return {};
  }

  void setResult(String topicId, TopicResult result) {
    state = {...state, topicId: result};
  }

  void removeResult(String topicId) {
    final newState = {...state};
    newState.remove(topicId);
    state = newState;
  }

  void clearAll() {
    state = {};
  }
}
