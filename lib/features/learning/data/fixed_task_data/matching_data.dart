import 'package:school_tasks/features/learning/domain/task_data/matching_task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

final matchingTasks = [
  MatchingTaskData(
    prompt: TaskPrompt(
      content: [TextContent('З’єднай приклади з правильними відповідями.')],
    ),
    pairs: [
      MatchingPair(left: TextContent('2 × 3'), right: TextContent('6')),
      MatchingPair(left: TextContent('3 × 2'), right: TextContent('6')),
      MatchingPair(left: TextContent('4 × 2'), right: TextContent('8')),
      MatchingPair(left: TextContent('5 × 2'), right: TextContent('10')),
      MatchingPair(left: TextContent('3 × 3'), right: TextContent('9')),
      MatchingPair(left: TextContent('2 × 5'), right: TextContent('10')),
    ],
    pairCount: 4,
  ),
];
