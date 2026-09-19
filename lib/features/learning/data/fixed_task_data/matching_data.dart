import 'package:school_tasks/features/learning/domain/task_data/matching_task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

final matchingTasks = [
  MatchingTaskData(
    prompt: TaskPrompt(
      content: [TextContent('З’єднай приклади з правильними відповідями.')],
    ),
    pairs: [
      MatchingPair(
        left: AudioContent.fixed('assets/audio/dva.mp3'),
        right: TextContent('2'),
      ),
      MatchingPair(left: TextContent('3 × 2'), right: TextContent('6')),
      MatchingPair(left: TextContent('2 × 3'), right: TextContent('6')),
      MatchingPair(
        left: ImageContent('assets/images/cheetah.png'),
        right: TextContent('5 × 2'),
      ),
      MatchingPair(
        left: AudioContent.fixed('assets/audio/devjat.mp3'),
        right: TextContent('9'),
      ),
      MatchingPair(
        left: EmojiContent('🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎'),
        right: TextContent('2 × 5'),
      ),
    ],
    pairCount: 6,
  ),
];
