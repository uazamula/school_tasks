import 'task_data.dart';

class ChoiceTaskData extends TaskData {
  const ChoiceTaskData({
    required super.condition,
    required this.correctAnswer,
    required this.answers,
  });

  final int correctAnswer;
  final List<int> answers;
}
