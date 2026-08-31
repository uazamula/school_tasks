import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';

class SelectionTaskData<TOption> extends TaskData {
  const SelectionTaskData({
    required super.prompt,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.correctAnswerCount,
    required this.wrongAnswerCount,
  });

  final List<TOption> correctAnswers;
  final List<TOption> wrongAnswers;

  final int correctAnswerCount;
  final int wrongAnswerCount;
}
