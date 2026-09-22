import 'package:school_tasks/features/learning/domain/rational.dart';
import 'package:school_tasks/features/learning/domain/task_data/input_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_mode.dart';

abstract final class AdditionTaskData {
  static final List<TaskData> within10 = [
    const SelectionTaskData(
      prompt: TaskPrompt(content: [TextContent('Скільки буде 2 + 2?')]),
      correctAnswers: ['4'],
      wrongAnswers: ['1', '3', '7'],
      wrongAnswerCount: 3,
    ),

    InputTaskData(
      prompt: const TaskPrompt(content: [TextContent('Скільки буде 3 + 4?')]),
      correctAnswer: Rational(7),
      inputMode: InputMode.integer,
    ),

    const SelectionTaskData(
      prompt: TaskPrompt(content: [TextContent('Скільки буде 1 + 5?')]),
      correctAnswers: ['6'],
      wrongAnswers: ['4', '5', '8'],
      wrongAnswerCount: 3,
    ),

    InputTaskData(
      prompt: TaskPrompt(content: [TextContent('Скільки буде 2 + 6?')]),
      correctAnswer: Rational(8),
      inputMode: InputMode.decimal,
    ),

    InputTaskData(
      prompt: TaskPrompt(content: [TextContent('Скільки буде 3 + 2?')]),
      correctAnswer: Rational(5),
      inputMode: InputMode.integer,
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
