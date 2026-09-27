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
      parts: 4,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж половину піци.")]),
      numerator: 1,
      denominator: 2,
      parts: 6,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж дві третини пирога.")]),
      numerator: 2,
      denominator: 3,
      parts: 6,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж третину шоколадки.")]),
      numerator: 1,
      denominator: 3,
      parts: 6,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж чверть торта.")]),
      numerator: 1,
      denominator: 4,
      parts: 8,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж половину піци.")]),
      numerator: 2,
      denominator: 4,
      parts: 8,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж три чверті пирога.")]),
      numerator: 3,
      denominator: 4,
      parts: 8,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж третину торта.")]),
      numerator: 1,
      denominator: 3,
      parts: 9,
    ),

    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж дві третини шоколадки.")]),
      numerator: 4,
      denominator: 6,
      parts: 9,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж половину пирога.")]),
      numerator: 1,
      denominator: 2,
      parts: 10,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж три п'ятих торта.")]),
      numerator: 3,
      denominator: 5,
      parts: 10,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 4/8 піци.")]),
      numerator: 4,
      denominator: 8,
      parts: 10,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж третину піци.")]),
      numerator: 1,
      denominator: 3,
      parts: 12,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж половину шоколадки.")]),
      numerator: 1,
      denominator: 2,
      parts: 12,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж чверть торта.")]),
      numerator: 1,
      denominator: 4,
      parts: 12,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 1/6 пирога.")]),
      numerator: 1,
      denominator: 6,
      parts: 12,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж половину піци.")]),
      numerator: 1,
      denominator: 2,
      parts: 14,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж чотири сьомих торта.")]),
      numerator: 4,
      denominator: 7,
      parts: 14,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 2/7 шоколадки.")]),
      numerator: 2,
      denominator: 7,
      parts: 14,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж одну третину пирога.")]),
      numerator: 1,
      denominator: 3,
      parts: 15,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 2/5 піци.")]),
      numerator: 2,
      denominator: 5,
      parts: 15,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж дві третини торта.")]),
      numerator: 8,
      denominator: 12,
      parts: 15,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж половину пирога.")]),
      numerator: 1,
      denominator: 2,
      parts: 16,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 3/8 шоколадки.")]),
      numerator: 3,
      denominator: 8,
      parts: 16,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 1/4 піци.")]),
      numerator: 1,
      denominator: 4,
      parts: 16,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж половину торта.")]),
      numerator: 1,
      denominator: 2,
      parts: 18,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж п'ять дев'ятих пирога.")]),
      numerator: 5,
      denominator: 9,
      parts: 18,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж третину шоколадки.")]),
      numerator: 1,
      denominator: 3,
      parts: 18,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж половину піци.")]),
      numerator: 1,
      denominator: 2,
      parts: 20,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 3/12 торта.")]),
      numerator: 3,
      denominator: 12,
      parts: 20,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 1/5 пирога.")]),
      numerator: 1,
      denominator: 5,
      parts: 20,
    ),
  ];
}
