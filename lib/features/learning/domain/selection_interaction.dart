import 'task_interaction.dart';

enum SelectionMode { single, multiple }

class SelectionInteraction extends TaskInteraction {
  const SelectionInteraction({required this.mode});

  final SelectionMode mode;

  bool get isSingle => mode == SelectionMode.single;

  bool get isMultiple => mode == SelectionMode.multiple;
}
