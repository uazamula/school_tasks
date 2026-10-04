import 'package:flutter/painting.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_button_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_linked_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

const configCompact = MatchingButtonConfig(
  fontSize: 16,
  buttonWidth: 120,
  buttonHeight: 56,
  spacing: 8,
);

const configStandard = MatchingButtonConfig(
  fontSize: 20,
  buttonWidth: 160,
  buttonHeight: 72,
  spacing: 16,
);

const configLarge = MatchingButtonConfig(
  fontSize: 46,
  buttonWidth: 220,
  buttonHeight: 110,
  spacing: 24,
);

const configNarrow = MatchingButtonConfig(
  fontSize: 24,
  buttonWidth: 160,
  buttonHeight: 160,
  spacing: 8,
);

const configWithScaler = MatchingButtonConfig(
  fontSize: 20,
  buttonWidth: 160,
  buttonHeight: 72,
  spacing: 16,
  textScaler: TextScaler.linear(1.3),
);

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
          content: TextContent('🍎🍎🍎🍎🍎🍎🍎🍎🍎'),
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
    pairCount: 7,
    buttonConfig: configLarge,
  ),

  MatchingTaskData(
    prompt: TaskPrompt(content: [TextContent('З’єднай відповідні пари')]),
    pairs: [
      MatchingPair(left: TextContent('Кіт'), right: TextContent('🐱')),
      MatchingPair(left: TextContent('Собака'), right: TextContent('🐶')),
      MatchingPair(
        left: TextContent(
          'Корова Бик Теля Корівка Телятко Корова Бик Теля Корівка',
        ),
        right: TextContent('🐄'),
      ),
      MatchingPair(left: TextContent('Кінь'), right: TextContent('🐴')),
      MatchingPair(
        left: TextContent('Свиня Хряк Кабан Корова Бик Теля Корівка'),
        right: TextContent('🐷'),
      ),
      MatchingPair(left: TextContent('Кролик'), right: EmojiContent('🐰')),
    ],
    pairCount: 6,
    buttonConfig: configWithScaler,
  ),
];
