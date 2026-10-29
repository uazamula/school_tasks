import 'package:flutter/cupertino.dart';
import 'package:school_tasks/features/learning/domain/task_data/selection_button_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/slot_assembly_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_linked_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/target_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/slot_assembly_interaction_mode.dart';

final myButtonConfig = SelectionButtonConfig(
  fontSize: 10,
  buttonWidth: 60,
  buttonHeight: 60,
  spacing: 4,
  textScaler: TextScaler.noScaling,
);
const subscriptDigits = '₀₁₂₃₄₅₆₇₈₉';

String toSubscript(int number) {
  return number
      .toString()
      .split('')
      .map((digit) => subscriptDigits[int.parse(digit)])
      .join();
}

final List<TaskData> slotAssemblyWord = [
  SlotAssemblyTaskData(
    prompt: TaskPrompt(
      content: [TextContent('Склади слово')],
      target: TargetContent(
        target: AudioLinkedContent(
          content: ImageContent('assets/images/fish.png'),
          audio: AudioContent.fixed('assets/audio/pronunciation/uk_ryba.mp3'),
        ),
        effect: const TargetEffectConfig(
          type: TargetEffectType.saturation,
          steps: 2,
        ),
      ),
    ),
    correctAnswers: [
      AudioLinkedContent(
        content: TextContent('РИ'),
        audio: AudioContent.fixed('assets/audio/pronunciation/uk_ry.mp3'),
      ),
      'БА',
    ],
    wrongAnswers: [],
    wrongAnswerCount: 0,
    buttonConfig: myButtonConfig,
    // requiresSequentialSelection: false,
    interactionMode: DragToSlotInteractionMode(),
  ),
  SlotAssemblyTaskData<AudioLinkedContent>(
    prompt: TaskPrompt(
      content: [TextContent('Склади слово')],
      target: TargetContent(
        target: ImageContent('assets/images/cheese.png'),
        effect: const TargetEffectConfig(
          type: TargetEffectType.saturation,
          steps: 1,
        ),
      ),
    ),
    correctAnswers: [
      AudioLinkedContent(
        content: TextContent('СИР'),
        audio: AudioContent.fixed('assets/audio/pronunciation/uk_syr.mp3'),
      ),
    ],
    wrongAnswers: [
      AudioLinkedContent(
        content: TextContent('강'),
        audio: AudioContent.fixed('assets/audio/pronunciation/uk_ra.mp3'),
      ),
    ],
    wrongAnswerCount: 1,
    buttonConfig: myButtonConfig,
  ),
  SlotAssemblyTaskData<AudioLinkedContent>(
    prompt: TaskPrompt(
      content: [TextContent('Склади слово')],
      target: TargetContent(
        target: ImageContent('assets/images/cow.png'),
        effect: const TargetEffectConfig(
          type: TargetEffectType.saturation,
          steps: 3,
        ),
      ),
    ),
    correctAnswers: [
      AudioLinkedContent(
        content: TextContent('КО'),
        audio: AudioContent.fixed('assets/audio/pronunciation/uk_ko.mp3'),
      ),
      AudioLinkedContent(
        content: TextContent('РО'),
        audio: AudioContent.fixed('assets/audio/pronunciation/uk_ro.mp3'),
      ),
      AudioLinkedContent(
        content: TextContent('ВА'),
        audio: AudioContent.fixed('assets/audio/pronunciation/uk_va.mp3'),
      ),
    ],
    wrongAnswers: [
      AudioLinkedContent(
        content: TextContent('РА'),
        audio: AudioContent.fixed('assets/audio/pronunciation/uk_ra.mp3'),
      ),
      // AudioLinkedContent(
      //   content: TextContent('ру'),
      //   audio: AudioContent.fixed('assets/audio/pronunciation/uk_ru.mp3'),
      // ),
    ],
    wrongAnswerCount: 1,
    interactionMode: const PressForSlotInteractionMode(
      fallingElementsEnabled: true,
      flightAnimationEnabled: true,
    ),
    requiresSequentialSelection: false,
  ),
  SlotAssemblyTaskData(
    prompt: TaskPrompt(
      content: [TextContent('Склади хімічну формулу')],
      target: TargetContent(target: TextContent('Сірчана кислота')),
    ),
    correctAnswers: ['H${toSubscript(2)}', 'SO${toSubscript(4)}'],
    wrongAnswers: ['SO${toSubscript(3)}'],
    wrongAnswerCount: 1,
    buttonConfig: myButtonConfig,
  ),
];
