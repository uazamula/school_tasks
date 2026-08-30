import 'task_data.dart';

class ChoiceTaskData extends TaskData {
  const ChoiceTaskData({
    required super.prompt,
    required this.correctAnswer,
    required this.answers,
  });

  final int correctAnswer;
  final List<int> answers;
}
