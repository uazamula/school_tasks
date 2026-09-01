import 'package:school_tasks/features/learning/domain/task_data/numeric_input_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

abstract final class MultiplicationTaskData {
  static List<TaskData> multiplicationTable = [
    SelectionTaskData(
      prompt: TaskPrompt(
        content: [
          TextContent('Скільки яблук на малюнку?'),
          GridContent(
            rows: 3,
            columns: 4,
            item: ImageContent('assets/images/tasks/square.png'),
          ),
        ],
      ),
      correctAnswers: ['12'],
      wrongAnswers: ['13', '14', '17'],
      wrongAnswerCount: 3,
    ),

    SelectionTaskData(
      prompt: TaskPrompt(
        content: [
          TextContent('Скільки яблук на малюнку?'),
          GridContent(
            rows: 5,
            columns: 4,
            item: ImageContent('assets/images/tasks/square.png'),
          ),
        ],
      ),
      correctAnswers: ['20'],
      wrongAnswers: ['13', '14', '17', '15'],
      wrongAnswerCount: 3,
    ),

    NumericInputTaskData(
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
    ),
  ];
}
