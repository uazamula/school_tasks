import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';

class SingleChoiceTaskData extends TaskData {
  const SingleChoiceTaskData({
    required super.prompt,
    required this.correctAnswers,
    required this.wrongAnswers,
  });

  final List<String> correctAnswers;
  final List<String> wrongAnswers;
}
