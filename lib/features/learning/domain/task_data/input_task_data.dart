import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_mode.dart';

class InputTaskData extends TaskData {
  const InputTaskData({
    required super.prompt,
    required this.correctAnswer,
    required this.inputMode,
  });

  final int correctAnswer;
  final InputMode inputMode;
}
