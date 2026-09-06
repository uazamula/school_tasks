import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';

class MatchingTaskData extends TaskData {
  const MatchingTaskData({
    required super.prompt,
    required this.pairs,
    required this.pairCount,
  });

  /// Банк усіх можливих пар.
  final List<MatchingPair> pairs;

  /// Кількість пар, які потрібно відібрати для конкретного завдання.
  final int pairCount;
}
