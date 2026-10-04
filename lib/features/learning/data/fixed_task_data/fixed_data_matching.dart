import 'package:school_tasks/features/learning/domain/task_data/matching_task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_linked_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

final matchingTasks = [
  MatchingTaskData(
    prompt: TaskPrompt(
      content: [TextContent('З’єднай приклади з правильними відповідями.')],
    ),
    pairs: [
      MatchingPair(left: EmojiContent('🦌'), right: TextContent('1')),
      MatchingPair(left: TextContent('2 × 3'), right: TextContent('6')),
      MatchingPair(
        left: ImageContent('assets/images/cheetah.png'),
        right: TextContent('5 × 2'),
      ),
      MatchingPair(
        left: AudioContent.localized({
          'uk': 'assets/audio/devjat.mp3',
          'tr': 'assets/audio/tr_dokuz.mp3',
        }),
        right: TextContent('9'),
      ),
      MatchingPair(
        left: TextContent('🍎🍎🍎🍎🍎\n🍎🍎🍎🍎🍎'),
        right: TextContent('10'),
      ),
      MatchingPair(
        left: AudioLinkedContent(
          content: TextContent('🍎🍎🍎🍎🍎\n🍎🍎🍎🍎'),
          audio: AudioContent.fixed('assets/audio/devjat.mp3'),
        ),
        right: TextContent('9'),
      ),
      MatchingPair(
        left: AudioLinkedContent(
          content: ImageContent('assets/images/tasks/apple.png'),
          audio: AudioContent.fixed('assets/audio/ding.mp3'),
        ),
        right: TextContent('яблуко'),
      ),
    ],
    pairCount: 6,
  ),
];
