import 'package:school_tasks/features/learning/domain/tasks/interactions/task_interaction.dart';

class SlotAssemblyInteraction extends TaskInteraction {
  const SlotAssemblyInteraction({
    required this.requiresSequentialSelection,
  });

  final bool requiresSequentialSelection;
}