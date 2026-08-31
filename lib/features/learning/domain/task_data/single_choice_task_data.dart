import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';

class SingleChoiceTaskData extends TaskData {
  const SingleChoiceTaskData({
    required super.prompt,
    required this.correctAnswer,
    required this.answers,
  });

  final int correctAnswer;
  final List<int> answers;
}
