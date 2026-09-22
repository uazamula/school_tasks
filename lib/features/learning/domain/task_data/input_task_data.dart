import 'package:school_tasks/features/learning/domain/rational.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_mode.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/tolerance_config.dart';

class InputTaskData extends TaskData {
  const InputTaskData({
    required super.prompt,
    required this.correctAnswer,
    required this.inputMode,
    this.tolerance = const ExactToleranceConfig(),
  });

  final Rational correctAnswer;
  final InputMode inputMode;
  final ToleranceConfig tolerance;
}
