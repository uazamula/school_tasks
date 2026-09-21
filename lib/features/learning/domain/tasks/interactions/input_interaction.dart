import 'package:school_tasks/features/learning/domain/tasks/input_mode.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/task_interaction.dart';

class InputInteraction extends TaskInteraction {
  const InputInteraction({required this.inputMode});

  final InputMode inputMode;
}
