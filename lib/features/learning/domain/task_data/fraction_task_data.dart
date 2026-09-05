import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';

class FractionTaskData extends TaskData {
  const FractionTaskData({
    required super.prompt,
    required this.numerator,
    required this.denominator,
    required this.parts,
  });

  final int numerator;
  final int denominator;
  final int parts;
}
