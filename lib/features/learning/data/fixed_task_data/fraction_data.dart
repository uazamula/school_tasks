import 'package:school_tasks/features/learning/domain/task_data/fraction_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

abstract final class FractionData {
  static const List<TaskData> fractions = [
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж половину торта.")]),
      numerator: 1,
      denominator: 2,
      parts: 6,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж дві четверті торта.")]),
      numerator: 2,
      denominator: 4,
      parts: 8,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж дві четверті торта.")]),
      numerator: 2,
      denominator: 4,
      parts: 6,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 3/7 торта.")]),
      numerator: 3,
      denominator: 7,
      parts: 7,
    ),
  ];
}
