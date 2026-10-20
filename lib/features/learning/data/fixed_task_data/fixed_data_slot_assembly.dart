import 'package:school_tasks/features/learning/domain/task_data/slot_assembly_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

final List<TaskData> slotAssemblyWord = [
  SlotAssemblyTaskData<String>(
    prompt: TaskPrompt(content: [TextContent('Склади слово')]),
    target: ImageContent('assets/images/cow.png'),
    correctAnswers: ['КО', 'РО', 'ВА'],
    wrongAnswers: ['ЛА', 'СИ', 'МО'],
    wrongAnswerCount: 2,
    requiresSequentialSelection: true,
  ),
];
