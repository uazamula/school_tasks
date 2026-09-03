import 'package:school_tasks/features/learning/domain/task_data/selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

abstract final class GeometryShapesData {
  static const List<TaskData> simpleShapes = [
    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [
          TextContent('Що зображено на малюнку?'),
          ImageContent('assets/images/tasks/square.png'),
        ],
      ),
      correctAnswers: ['Прямокутник', 'Ромб', 'Паралелограм'],
      wrongAnswers: ['Коло'],
      correctAnswerCount: 3,
      wrongAnswerCount: 1,
    ),

    SelectionTaskData<String>(
      prompt: TaskPrompt(content: [TextContent('Що є паралелограмом завжди?')]),
      correctAnswers: ['Прямокутник', 'Квадрат'],
      wrongAnswers: ['Трапеція', 'Коло', 'Трикутник'],
      correctAnswerCount: 2,
      wrongAnswerCount: 2,
    ),
  ];

  static List<TaskData> shapes = [
    SelectionTaskData<ImageContent>(
      prompt: TaskPrompt(
        content: [TextContent('На якій картинці зображено коло?')],
      ),
      correctAnswers: [ImageContent('assets/images/tasks/circle.png')],
      wrongAnswers: [
        ImageContent('assets/images/tasks/triangle.png'),
        ImageContent('assets/images/tasks/ellipse.png'),
        ImageContent('assets/images/tasks/square.png'),
      ],
      wrongAnswerCount: 3,
    ),

    SelectionTaskData<ImageContent>(
      prompt: TaskPrompt(
        content: [TextContent('На якій картинці зображено трикутник?')],
      ),
      correctAnswers: [ImageContent('assets/images/tasks/triangle.png')],
      wrongAnswers: [
        ImageContent('assets/images/tasks/circle.png'),
        ImageContent('assets/images/tasks/ellipse.png'),
        ImageContent('assets/images/tasks/square.png'),
      ],
      wrongAnswerCount: 3,
    ),
    SelectionTaskData<ImageContent>(
      prompt: TaskPrompt(content: [TextContent('Вибери багатокутники.')]),
      correctAnswers: [
        ImageContent('assets/images/tasks/triangle.png'),
        ImageContent('assets/images/tasks/square.png'),
      ],
      wrongAnswers: [
        ImageContent('assets/images/tasks/circle.png'),
        ImageContent('assets/images/tasks/ellipse.png'),
      ],
      correctAnswerCount: 2,
      wrongAnswerCount: 2,
    ),
  ];
}
