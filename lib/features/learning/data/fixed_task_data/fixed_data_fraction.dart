import 'package:school_tasks/features/learning/domain/task_data/fraction_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

abstract final class FractionData {
  static const List<TaskData> fractions = [
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж половину піци.")]),
      numerator: 1,
      denominator: 2,
      parts: 8,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж одну третину торта.")]),
      numerator: 1,
      denominator: 3,
      parts: 6,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж дві третини пирога.")]),
      numerator: 2,
      denominator: 3,
      parts: 9,
    ),
    FractionTaskData(
      prompt: TaskPrompt(
        content: [TextContent("З'їж одну четверту шоколадки.")],
      ),
      numerator: 1,
      denominator: 4,
      parts: 8,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж три четверті піци.")]),
      numerator: 3,
      denominator: 4,
      parts: 12,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж дві п'ятих торта.")]),
      numerator: 2,
      denominator: 5,
      parts: 10,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж чотири п'ятих пирога.")]),
      numerator: 4,
      denominator: 5,
      parts: 10,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж одну шосту піци.")]),
      numerator: 1,
      denominator: 6,
      parts: 12,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж п'ять шостих торта.")]),
      numerator: 5,
      denominator: 6,
      parts: 12,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж дві сьомих шоколадки.")]),
      numerator: 2,
      denominator: 7,
      parts: 14,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж п'ять сьомих пирога.")]),
      numerator: 5,
      denominator: 7,
      parts: 14,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж три восьмих піци.")]),
      numerator: 3,
      denominator: 8,
      parts: 16,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж сім восьмих торта.")]),
      numerator: 7,
      denominator: 8,
      parts: 16,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж три дев'ятих пирога.")]),
      numerator: 3,
      denominator: 9,
      parts: 18,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж п'ять дев'ятих піци.")]),
      numerator: 5,
      denominator: 9,
      parts: 18,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж одну десяту шоколадки.")]),
      numerator: 1,
      denominator: 10,
      parts: 10,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж сім десятих торта.")]),
      numerator: 7,
      denominator: 10,
      parts: 20,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж пʼяту частину пирога.")]),
      numerator: 1,
      denominator: 5,
      parts: 10,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж три чверті піци.")]),
      numerator: 3,
      denominator: 4,
      parts: 12,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж третину торта.")]),
      numerator: 1,
      denominator: 3,
      parts: 15,
    ),
  ];
}
