import 'task_data.dart';

class NumericInputTaskData extends TaskData {
  const NumericInputTaskData({
    required super.condition,
    required this.correctAnswer,
  });

  final int correctAnswer;
}
