import 'task_data.dart';

class MultiChoiceTaskData extends TaskData {
  const MultiChoiceTaskData({
    required super.prompt,
    this.imagePath,
    required this.correctAnswers,
    required this.wrongAnswers,
  });

  final String? imagePath;
  final List<String> correctAnswers;
  final List<String> wrongAnswers;
}
