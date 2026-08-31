import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';

class NumericInputTaskData extends TaskData {
  const NumericInputTaskData({
    required super.prompt,
    required this.correctAnswer,
  });

  final int correctAnswer;
}
