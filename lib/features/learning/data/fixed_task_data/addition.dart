import 'package:school_tasks/features/learning/domain/task_data/choice_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/numeric_input_task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

abstract final class AdditionTaskData {
  static const List<TaskData> within10 = [
    ChoiceTaskData(
      prompt: TaskPrompt(content: [TextContent('Скільки буде 2 + 2?')]),
      correctAnswer: 4,
      answers: [1, 3, 4, 7],
    ),
    NumericInputTaskData(
      prompt: TaskPrompt(content: [TextContent('Скільки буде 3 + 4?')]),
      correctAnswer: 7,
    ),
    ChoiceTaskData(
      prompt: TaskPrompt(content: [TextContent('Скільки буде 1 + 5?')]),
      correctAnswer: 6,
      answers: [4, 5, 6, 8],
    ),
    NumericInputTaskData(
      prompt: TaskPrompt(content: [TextContent('Скільки буде 2 + 6?')]),
      correctAnswer: 8,
    ),
    NumericInputTaskData(
      prompt: TaskPrompt(content: [TextContent('Скільки буде 3 + 2?')]),
      correctAnswer: 5,
    ),
  ];

  static const List<TaskData> additionDigits = [
    ChoiceTaskData(
      prompt: TaskPrompt(content: [TextContent('Скільки буде 2 + 9?')]),
      correctAnswer: 11,
      answers: [11, 13, 14, 17],
    ),
    ChoiceTaskData(
      prompt: TaskPrompt(content: [TextContent('Скільки буде 3 + 10?')]),
      correctAnswer: 13,
      answers: [3, 10, 11, 13],
    ),
    ChoiceTaskData(
      prompt: TaskPrompt(content: [TextContent('Скільки буде 6 + 5?')]),
      correctAnswer: 11,
      answers: [10, 11, 12, 13],
    ),
  ];
}
