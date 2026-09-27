import 'package:school_tasks/features/learning/domain/task_data/fraction_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

abstract final class PercentData {
  static const List<TaskData> percents = [
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 50% торта.")]),
      numerator: 1,
      denominator: 2,
      parts: 4,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 25% шоколадки.")]),
      numerator: 1,
      denominator: 4,
      parts: 4,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 100% піци.")]),
      numerator: 2,
      denominator: 2,
      parts: 6,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 50% пирога.")]),
      numerator: 1,
      denominator: 2,
      parts: 6,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 25% торта.")]),
      numerator: 1,
      denominator: 4,
      parts: 8,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 50% піци.")]),
      numerator: 2,
      denominator: 4,
      parts: 8,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 75% пирога.")]),
      numerator: 3,
      denominator: 4,
      parts: 8,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 50% торта.")]),
      numerator: 1,
      denominator: 2,
      parts: 10,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 40% шоколадки.")]),
      numerator: 4,
      denominator: 10,
      parts: 10,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 30% пирога.")]),
      numerator: 3,
      denominator: 10,
      parts: 10,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 20% торта.")]),
      numerator: 1,
      denominator: 5,
      parts: 10,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 70% піци.")]),
      numerator: 7,
      denominator: 10,
      parts: 10,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 25% піци.")]),
      numerator: 1,
      denominator: 4,
      parts: 12,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 50% шоколадки.")]),
      numerator: 1,
      denominator: 2,
      parts: 12,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 75% торта.")]),
      numerator: 3,
      denominator: 4,
      parts: 12,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 50% піци.")]),
      numerator: 1,
      denominator: 2,
      parts: 14,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 20% шоколадки.")]),
      numerator: 1,
      denominator: 5,
      parts: 15,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 60% пирога.")]),
      numerator: 3,
      denominator: 5,
      parts: 15,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 40% піци.")]),
      numerator: 2,
      denominator: 5,
      parts: 15,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 80% торта.")]),
      numerator: 4,
      denominator: 5,
      parts: 15,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 50% пирога.")]),
      numerator: 1,
      denominator: 2,
      parts: 16,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 25% шоколадки.")]),
      numerator: 1,
      denominator: 4,
      parts: 16,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 75% піци.")]),
      numerator: 3,
      denominator: 4,
      parts: 16,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 50% торта.")]),
      numerator: 1,
      denominator: 2,
      parts: 18,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 5% піци.")]),
      numerator: 1,
      denominator: 20,
      parts: 20,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 10% торта.")]),
      numerator: 1,
      denominator: 10,
      parts: 20,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 15% пирога.")]),
      numerator: 3,
      denominator: 20,
      parts: 20,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 20% пирога.")]),
      numerator: 4,
      denominator: 20,
      parts: 20,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 25% торта.")]),
      numerator: 1,
      denominator: 4,
      parts: 20,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 30% пирога.")]),
      numerator: 3,
      denominator: 10,
      parts: 20,
    ),
    FractionTaskData(
      prompt: TaskPrompt(content: [TextContent("З'їж 40% шоколадки.")]),
      numerator: 4,
      denominator: 10,
      parts: 20,
    ),
  ];
}
