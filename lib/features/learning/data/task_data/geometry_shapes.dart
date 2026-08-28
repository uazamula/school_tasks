import 'package:school_tasks/features/learning/domain/multi_choice_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data.dart';

abstract final class GeometryShapesData {
  static const List<TaskData> simpleShapes = [
    MultiChoiceTaskData(
      condition: 'Що зображено на малюнку?',
      imagePath: 'assets/images/tasks/square.png',
      correctAnswers: ['Прямокутник', 'Ромб', 'Паралелограм'],
      wrongAnswers: ['Коло'],
    ),
    MultiChoiceTaskData(
      condition: 'Що є паралелограмом завжди?',
      correctAnswers: ['Прямокутник', 'Квадрат'],
      wrongAnswers: ['Трапеція', 'Коло'],
    ),
  ];
}
