import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/ui/active_profile_provider.dart';
import 'package:school_tasks/features/learning/domain/evaluation/topic_result_attempt.dart';
import 'package:school_tasks/features/learning/domain/evaluation/topic_result_display.dart';
import 'package:school_tasks/features/learning/providers/topic_result_attempt_controller.dart';
import 'package:school_tasks/features/learning/providers/topic_result_display_controller.dart';

/// Яку спробу показувати: вибір користувача або значення профілю.
final effectiveTopicResultAttemptProvider = Provider<TopicResultAttempt>((ref) {
  final chosen = ref.watch(topicResultAttemptControllerProvider).value;

  return chosen ?? ref.watch(activeProfileProvider).resultAttempt;
});

/// Як показувати результат: вибір користувача або значення профілю.
final effectiveTopicResultDisplayProvider = Provider<TopicResultDisplay>((ref) {
  final chosen = ref.watch(topicResultDisplayControllerProvider).value;

  return chosen ?? ref.watch(activeProfileProvider).resultDisplay;
});
