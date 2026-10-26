import 'package:school_tasks/features/learning/domain/task_data/selection_button_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/slot_assembly_interaction_mode.dart';

class SlotAssemblyTaskData<TOption> extends TaskData {
  const SlotAssemblyTaskData({
    required super.prompt,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.wrongAnswerCount,
    this.buttonConfig,
    this.requiresSequentialSelection = true,
    this.interactionMode = const PressForSlotInteractionMode(),
  });

  final List<TOption> correctAnswers;
  final List<TOption> wrongAnswers;
  final int wrongAnswerCount;
  final SelectionButtonConfig? buttonConfig;
  final bool requiresSequentialSelection;
  final SlotAssemblyInteractionMode interactionMode;
}
