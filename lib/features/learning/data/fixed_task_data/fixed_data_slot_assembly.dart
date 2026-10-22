import 'package:flutter/cupertino.dart';
import 'package:school_tasks/features/learning/domain/task_data/selection_button_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/slot_assembly_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_linked_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/target_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

final myButtonConfig = SelectionButtonConfig(
  fontSize: 10,
  buttonWidth: 60,
  buttonHeight: 60,
  spacing: 4,
  textScaler: TextScaler.noScaling,
);
final List<TaskData> slotAssemblyWord = [
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
        content: TextContent('сир'),
        audio: AudioContent.fixed('assets/audio/pronunciation/uk_syr.mp3'),
      ),
    ],
    wrongAnswers: [
      AudioLinkedContent(
        content: TextContent('ра'),
        audio: AudioContent.fixed('assets/audio/pronunciation/uk_ra.mp3'),
      ),
    ],
    wrongAnswerCount: 1,
    buttonConfig: myButtonConfig,
    fallingElementsEnabled: true,
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
        content: TextContent('ко'),
        audio: AudioContent.fixed('assets/audio/pronunciation/uk_ko.mp3'),
      ),
      AudioLinkedContent(
        content: TextContent('ро'),
        audio: AudioContent.fixed('assets/audio/pronunciation/uk_ro.mp3'),
      ),
      AudioLinkedContent(
        content: TextContent('ва'),
        audio: AudioContent.fixed('assets/audio/pronunciation/uk_va.mp3'),
      ),
    ],
    wrongAnswers: [
      AudioLinkedContent(
        content: TextContent('ра'),
        audio: AudioContent.fixed('assets/audio/pronunciation/uk_ra.mp3'),
      ),
    ],
    wrongAnswerCount: 1,
    buttonConfig: myButtonConfig,
    fallingElementsEnabled: false,
  ),
  SlotAssemblyTaskData<String>(
    prompt: TaskPrompt(
      content: [TextContent('Склади слово')],
      target: TargetContent(
        target: ImageContent('assets/images/fish.png'),
        effect: const TargetEffectConfig(
          type: TargetEffectType.saturation,
          steps: 2,
        ),
      ),
    ),
    correctAnswers: ['ри', 'ба'],
    wrongAnswers: ['ма', 'ши', 'на'],
    wrongAnswerCount: 3,
    buttonConfig: myButtonConfig,
  ),
];
