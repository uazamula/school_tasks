import 'package:school_tasks/features/learning/domain/task_data/input_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_mode.dart';

abstract final class MultiplicationTaskData {
  static List<TaskData> multiplicationTable = [
    SelectionTaskData(
      prompt: TaskPrompt(
        content: [
          TextContent('Скільки яблук на малюнку?'),
          GridContent(
            rows: 6,
            columns: 4,
            item: ImageContent('assets/images/tasks/apple.png'),
          ),
        ],
      ),
      correctAnswers: ['24', 'двадцять чотири'],
      wrongAnswers: ['13', '14', '15', '16', '17'],
      correctAnswerCount: 2,
      wrongAnswerCount: 5,
      requiresConfirmation: true,
    ),

    SelectionTaskData(
      prompt: TaskPrompt(
        content: [
          TextContent('Скільки яблук на малюнку?'),
          GridContent(
            rows: 5,
            columns: 4,
            item: ImageContent('assets/images/tasks/apple.png'),
          ),
        ],
      ),
      correctAnswers: ['20'],
      wrongAnswers: ['13', '14', '17', '15', '18', '19'],
      wrongAnswerCount: 6,
      requiresConfirmation: true,
    ),

    InputTaskData(
      prompt: TaskPrompt(
        content: [
          TextContent('Скільки квадратів на малюнку?'),
          GridContent(
            rows: 4,
            columns: 4,
            item: ImageContent('assets/images/tasks/square.png'),
          ),
        ],
      ),
      correctAnswer: 16,
      inputMode: InputMode.integer,
    ),
  ];
}
