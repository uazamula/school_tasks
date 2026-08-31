import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';

class MultiChoiceTaskData extends TaskData {
  const MultiChoiceTaskData({
    required super.prompt,
    this.imagePath,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.correctAnswerCount,
    required this.wrongAnswerCount,
  });

  final String? imagePath;

  final List<String> correctAnswers;
  final List<String> wrongAnswers;

  final int correctAnswerCount;
  final int wrongAnswerCount;
}
