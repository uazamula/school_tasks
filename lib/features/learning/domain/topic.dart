//Тут ми поки що явно описуємо саме правила генерації додавання.
// Це нормально для нашого мінімального робочого прикладу.
// Коли з'являться інші види навчального матеріалу, винесемо ці правила в окрему модель.
import 'package:school_tasks/features/learning/domain/learning_type_task.dart';

class Topic {
  const Topic({
    required this.id,
    required this.taskTypeCounts,
    required this.firstMin,
    required this.firstMax,
    required this.secondMin,
    required this.secondMax,
    required this.maxSum,
  });

  final String id;

  final Map<LearningTaskType, int> taskTypeCounts;

  final int firstMin;
  final int firstMax;
  final int secondMin;
  final int secondMax;
  final int maxSum;

  int get totalTasks {
    return taskTypeCounts.values.fold(0, (sum, count) => sum + count);
  }
}
