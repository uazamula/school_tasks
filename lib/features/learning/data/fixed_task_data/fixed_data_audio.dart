import 'package:school_tasks/features/learning/domain/task_data/selection_task_data.dart';

import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_linked_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

const List<TaskData> additionWithSound = [
  SelectionTaskData(
    prompt: TaskPrompt(
      content: [
        TextContent('Скільки буде 2 + 9?'),
        GridContent(
          rows: 3,
          columns: 4,
          item: ImageContent('assets/images/tasks/apple.png'),
        ),
        AudioContent.fixed('assets/audio/failure.mp3'),
        ImageContent('assets/images/tasks/triangle.png'),
      ],
    ),
    correctAnswers: ['11'],
    wrongAnswers: ['13', '14', '17'],
    wrongAnswerCount: 3,
    requiresConfirmation: true,
  ),
  SelectionTaskData(
    prompt: TaskPrompt(content: [TextContent('Скільки буде 2 + 5?')]),
    correctAnswers: [AudioContent.fixed('assets/audio/sim.mp3')],
    wrongAnswers: [
      AudioContent.localized({
        'uk': 'assets/audio/devjat.mp3',
        'tr': 'assets/audio/tr_dokuz.mp3',
      }),
      AudioContent.localized({'uk': 'assets/audio/dva.mp3'}),
    ],
    wrongAnswerCount: 2,
    requiresConfirmation: true,
  ),
];

const List<TaskData> audioLinkedPromptDemo = [
  SelectionTaskData(
    prompt: TaskPrompt(
      content: [
        TextContent('Натисни на текст, щоб прослухати аудіо:'),
        AudioLinkedContent(
          content: TextContent('Успіх'),
          audio: AudioContent.fixed('assets/audio/ding.mp3'),
        ),
        AudioLinkedContent(
          content: TextContent('Помилка'),
          audio: AudioContent.fixed('assets/audio/failure.mp3'),
        ),
      ],
    ),
    correctAnswers: ['Успіх'],
    wrongAnswers: ['Помилка'],
    wrongAnswerCount: 1,
    requiresConfirmation: false,
  ),

  SelectionTaskData(
    prompt: TaskPrompt(
      content: [
        TextContent('Натисни на об\'єкт, щоб почути його назву.'),

        AudioLinkedContent(
          content: ImageContent('assets/images/tasks/apple.png'),
          audio: AudioContent.fixed('assets/audio/sim.mp3'),
        ),
      ],
    ),
    correctAnswers: ['apple'],
    wrongAnswers: ['banana'],
    wrongAnswerCount: 1,
    requiresConfirmation: false,
  ),
];

const List<TaskData> audioLinkedSelectionDemo = [
  // 1. Emoji + Single Choice
  SelectionTaskData(
    prompt: TaskPrompt(
      content: [
        TextContent('Скільки яблук?'),
        AudioLinkedContent(
          content: EmojiContent('🍎🍎🍎'),
          audio: AudioContent.fixed('assets/audio/sim.mp3'),
        ),
      ],
    ),
    correctAnswers: ['3'],
    wrongAnswers: ['2', '4', '5'],
    wrongAnswerCount: 3,
    requiresConfirmation: false,
  ),

  // 2. Emoji + Multi Choice
  SelectionTaskData(
    prompt: TaskPrompt(
      content: [
        TextContent('Обери всі числа, які можна почути:'),
        AudioLinkedContent(
          content: EmojiContent('🔊 2'),
          audio: AudioContent.fixed('assets/audio/dva.mp3'),
        ),
        AudioLinkedContent(
          content: EmojiContent('🔊 9'),
          audio: AudioContent.fixed('assets/audio/devjat.mp3'),
        ),
        AudioLinkedContent(
          content: EmojiContent('🔊 2'),
          audio: AudioContent.fixed('assets/audio/dva.mp3'),
        ),
      ],
    ),
    correctAnswers: ['🔊 2', '🔊 9'],
    wrongAnswers: ['🔊 5'],
    wrongAnswerCount: 1,
    requiresConfirmation: true,
  ),

  // 3. Image + Single Choice
  SelectionTaskData(
    prompt: TaskPrompt(
      content: [TextContent('Яке зображення відповідає слову «яблуко»?')],
    ),
    correctAnswers: [
      AudioLinkedContent(
        content: ImageContent('assets/images/tasks/apple.png'),
        audio: AudioContent.fixed('assets/audio/sim.mp3'),
      ),
    ],
    wrongAnswers: [
      ImageContent('assets/images/tasks/triangle.png'),
      EmojiContent('🍌'),
      EmojiContent('🍐'),
    ],
    wrongAnswerCount: 3,
    requiresConfirmation: false,
  ),

  // 4. Image + Multi Choice
  SelectionTaskData(
    prompt: TaskPrompt(
      content: [TextContent('Обери всі предмети, назви яких можна почути.')],
    ),
    correctAnswers: [
      AudioLinkedContent(
        content: ImageContent('assets/images/tasks/apple.png'),
        audio: AudioContent.fixed('assets/audio/sim.mp3'),
      ),
      AudioLinkedContent(
        content: ImageContent('assets/images/tasks/triangle.png'),
        audio: AudioContent.fixed('assets/audio/devjat.mp3'),
      ),
    ],
    wrongAnswers: [EmojiContent('🍌'), EmojiContent('🍐')],
    wrongAnswerCount: 2,
    requiresConfirmation: true,
  ),
];
