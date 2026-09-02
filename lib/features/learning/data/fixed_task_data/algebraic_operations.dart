import 'package:school_tasks/features/learning/domain/task_data/selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

abstract final class OperationsTaskData {
  static List<TaskData> simpleOperations = [
    SelectionTaskData(
      prompt: TaskPrompt(content: [TextContent('Що є результатом додавання')]),
      correctAnswers: ['сума'],
      wrongAnswers: ['різниця', 'добуток', 'частка'],
      wrongAnswerCount: 2,
    ),
    SelectionTaskData(
      prompt: TaskPrompt(
        content: [TextContent('Які елементи є в операції віднімання')],
      ),
      correctAnswers: ['зменшуване', 'відʼємник'],
      wrongAnswers: ['сума', 'добуток', 'частка'],
      wrongAnswerCount: 1,
    ),
  ];
}
