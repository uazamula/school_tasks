import 'package:school_tasks/features/learning/domain/multi_choice_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_content.dart';
import 'package:school_tasks/features/learning/domain/task_data.dart';
import 'package:school_tasks/features/learning/domain/task_prompt.dart';

abstract final class GeometryShapesData {
  static const List<TaskData> simpleShapes = [
    MultiChoiceTaskData(
      prompt: TaskPrompt(
        content: [
          TextContent('Що зображено на малюнку?'),
          ImageContent('assets/images/tasks/square.png'),
        ],
      ),
      correctAnswers: ['Прямокутник', 'Ромб', 'Паралелограм'],
      wrongAnswers: ['Коло'],
    ),
    MultiChoiceTaskData(
      prompt: TaskPrompt(content: [TextContent('Що є паралелограмом завжди?')]),
      correctAnswers: ['Прямокутник', 'Квадрат'],
      wrongAnswers: ['Трапеція', 'Коло'],
    ),
  ];
}
