import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';

/// Спосіб вибору частин: дотик, перетягування або обидва.
enum FractionSelectionMode { tap, drag, both }

class FractionTaskData extends TaskData {
  const FractionTaskData({
    required super.prompt,
    required this.numerator,
    required this.denominator,
    required this.parts,
    this.selectionMode = FractionSelectionMode.both,
  });

  final FractionSelectionMode selectionMode;
  final int numerator;
  final int denominator;
  final int parts;
}
