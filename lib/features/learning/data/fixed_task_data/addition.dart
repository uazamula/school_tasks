import 'package:school_tasks/features/learning/domain/task_data/selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/numeric_input_task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

abstract final class AdditionTaskData {
  static const List<TaskData> within10 = [
    SelectionTaskData(
      prompt: TaskPrompt(content: [TextContent('Скільки буде 2 + 2?')]),
      correctAnswers: ['4'],
      wrongAnswers: ['1', '3', '7'],
      wrongAnswerCount: 3,
    ),

    NumericInputTaskData(
      prompt: TaskPrompt(content: [TextContent('Скільки буде 3 + 4?')]),
      correctAnswer: 7,
    ),

    SelectionTaskData(
      prompt: TaskPrompt(content: [TextContent('Скільки буде 1 + 5?')]),
      correctAnswers: ['6'],
      wrongAnswers: ['4', '5', '8'],
      wrongAnswerCount: 3,
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
    SelectionTaskData(
      prompt: TaskPrompt(content: [TextContent('Скільки буде 2 + 9?')]),
      correctAnswers: ['11'],
      wrongAnswers: ['13', '14', '17'],
      wrongAnswerCount: 3,
    ),

    SelectionTaskData(
      prompt: TaskPrompt(content: [TextContent('Скільки буде 3 + 10?')]),
      correctAnswers: ['13'],
      wrongAnswers: ['3', '10', '11'],
      wrongAnswerCount: 3,
    ),

    SelectionTaskData(
      prompt: TaskPrompt(content: [TextContent('Скільки буде 6 + 5?')]),
      correctAnswers: ['11'],
      wrongAnswers: ['10', '12', '13'],
      wrongAnswerCount: 3,
    ),
  ];
}
