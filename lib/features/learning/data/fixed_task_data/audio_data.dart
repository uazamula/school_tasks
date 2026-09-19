import 'package:school_tasks/features/learning/domain/task_data/selection_task_data.dart';

import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
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
