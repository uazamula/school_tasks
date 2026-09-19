import 'package:school_tasks/features/learning/domain/tasks/interactions/task_interaction.dart';

class SelectionInteraction extends TaskInteraction {
  const SelectionInteraction({
    required this.requiresConfirmation,
    required this.isMultiple,
  });

  final bool requiresConfirmation;
  final bool isMultiple;

  bool get isSingle => !isMultiple;
}
