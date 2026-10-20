import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_button_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/selection_button_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/slot_assembly_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

final List<TaskData> slotAssemblyWord = [
  SlotAssemblyTaskData<String>(
    prompt: TaskPrompt(
      content: [
        TextContent('Склади слово'),
        ImageContent('assets/images/cow.png'),
      ],
    ),
    correctAnswers: ['КО', 'РО', 'ВА'],
    wrongAnswers: ['ЛА', 'СИ', 'МО'],
    wrongAnswerCount: 2,
    requiresSequentialSelection: true,
    buttonConfig: SelectionButtonConfig(
      fontSize: 10,
      buttonWidth: 60,
      buttonHeight: 60,
      spacing: 4,
      textScaler: TextScaler.noScaling,
    ),
  ),
];
