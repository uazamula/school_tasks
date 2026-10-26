import 'package:school_tasks/features/learning/domain/tasks/interactions/slot_assembly_interaction_mode.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/task_interaction.dart';

class SlotAssemblyInteraction extends TaskInteraction {
  const SlotAssemblyInteraction({
    required this.requiresSequentialSelection,
    required this.mode,
  });

  final bool requiresSequentialSelection;
  final SlotAssemblyInteractionMode mode;
}
