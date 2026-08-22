import 'task_data.dart';

class MultiChoiceTaskData extends TaskData {
  const MultiChoiceTaskData({
    required super.condition,
    required this.imagePath,
    required this.answers,
    required this.correctAnswers,
  });

  final String imagePath;
  final List<String> answers;
  final List<String> correctAnswers;
}
