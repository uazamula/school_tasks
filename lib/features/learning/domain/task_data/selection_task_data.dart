import 'package:school_tasks/features/learning/domain/task_data/selection_button_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';

class SelectionTaskData<TOption> extends TaskData {
  const SelectionTaskData({
    required super.prompt,
    required this.correctAnswers,
    required this.wrongAnswers,
    this.correctAnswerCount = 1,
    required this.wrongAnswerCount,
    this.requiresConfirmation = false,
    this.buttonConfig,
  });

  final List<TOption> correctAnswers;
  final List<TOption> wrongAnswers;

  final int correctAnswerCount;
  final int wrongAnswerCount;

  final bool requiresConfirmation;

  final SelectionButtonConfig? buttonConfig;
}
