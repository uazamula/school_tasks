import 'package:school_tasks/core/theme/app_text_styles.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/matching_column_element.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/memory_pair_builder.dart';
import 'package:school_tasks/features/learning/data/word_content/syllable_audio_uk.dart';
import 'package:school_tasks/features/learning/data/word_content/word_bank.dart';
import 'package:school_tasks/features/learning/domain/automatic_termination_config.dart';
import 'package:school_tasks/features/learning/domain/dashboard_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/fixed_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/task_data/memory_card_style_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/memory_grid_size.dart';
import 'package:school_tasks/features/learning/domain/task_data/memory_task_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/memory_task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_order_mode.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_layout.dart';
import 'package:school_tasks/features/learning/domain/topic_progression_mode.dart';
import 'package:school_tasks/features/learning/domain/word_content/image_aspect.dart';
import 'package:school_tasks/features/learning/domain/word_content/language.dart';
import 'package:school_tasks/features/learning/domain/word_content/picture_source.dart';
import 'package:school_tasks/features/learning/domain/word_content/syllable_search_position.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_filter.dart';

final pairs1 = MemoryPairBuilder(
  bank: ukEnTrWordBank,
  minPairs: 3,
  filter: WordFilter(wordPattern: 'k*', position: SyllableSearchPosition.any),
  language: Language.tr,
  hiddenElement: MatchingColumnElement.word,
  faceFrontElement: MatchingColumnElement.word,
  faceBackElement: MatchingColumnElement.word,
  faceFrontLanguage: Language.uk,
  audioLanguage: Language.tr,
  audioPlace: MemoryAudioPlace.hidden,
  audioSource: MemoryAudioSource.word,
  syllableAudio: syllableAudioUk,
  //todo зробити false, щоб не виводило в консоль
  printDiagnostics: false,
).build();
final pairs2 = MemoryPairBuilder(
  bank: ukEnTrWordBank,
  minPairs: 5,
  language: Language.uk,
  hiddenElement: MatchingColumnElement.word,
  faceFrontElement: MatchingColumnElement.word,
  faceBackElement: MatchingColumnElement.image,
  faceFrontLanguage: Language.en,
  audioSource: MemoryAudioSource.none,
  syllableAudio: syllableAudioUk,
  //todo зробити false, щоб не виводило в консоль
  printDiagnostics: false,
).build();

final memoryTaskData1 = MemoryTaskData(
  prompt: _prompt('Знайди пару'),
  pairPool: pairs1,
  config: const MemoryTaskConfig(
    gridSize: MemoryGridSize.size3x2,
    replayAudioOnMatch: true,
    cardAspectRatio: 1,
    cardStyle: MemoryCardStyleConfig(
      // cover: MemoryCoverStyle(),
      front: MemoryFaceStyle(textStyle: AppTextStyles.headline),
    ),
  ),
);
final memoryTaskData2 = MemoryTaskData(
  prompt: _prompt('Знайди пару'),
  pairPool: [...pairs2],
  config: const MemoryTaskConfig(
    gridSize: MemoryGridSize.size3x2,
    replayAudioOnMatch: true,
    cardAspectRatio: 1,
    cardStyle: MemoryCardStyleConfig(
      // cover: MemoryCoverStyle(),
      front: MemoryFaceStyle(textStyle: AppTextStyles.headline),
    ),
  ),
);

TaskPrompt _prompt(String text) => TaskPrompt(content: [TextContent(text)]);

abstract final class MemoryLanguagesDemo {
  static final Topic topic = Topic(
    id: 'languages_memory',
    taskTypeCounts: {LearningTaskType.memory: 1},
    taskOrderMode: TaskOrderMode.deterministic,
    dataSource: FixedTaskDataSource([memoryTaskData1, memoryTaskData2]),
    help: 'Memory: скінченна дошка',
    evaluation: const EvaluationConfig(
      weights: {EvaluationCriterionType.accuracy: 1},
    ),
    progressionMode: TopicProgressionMode.automaticWithFeedback,
    automaticTermination: const AutomaticTerminationConfig(failureLimit: 5),
    dashboard: const DashboardConfig(showRemainingAttempts: true),
    layout: const TopicLayout.minimalPrompt(),
  );
}
