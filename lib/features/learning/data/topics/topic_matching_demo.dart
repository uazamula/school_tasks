import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/data/generation/generated_task_data_source.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/matching_column_element.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/matching_text_case.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/syllable_matching_task_data_generator.dart';
import 'package:school_tasks/features/learning/data/word_content/syllable_audio_uk.dart';
import 'package:school_tasks/features/learning/domain/automatic_termination_config.dart';
import 'package:school_tasks/features/learning/domain/composite_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/dashboard_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/passing_criteria.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_button_config.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_order_mode.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_layout.dart';
import 'package:school_tasks/features/learning/domain/topic_progression_mode.dart';
import 'package:school_tasks/features/learning/domain/word_content/language.dart';
import 'package:school_tasks/features/learning/domain/word_content/syllable_search_position.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_bank.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_builder.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_filter.dart';

final syllableDemoBank = WordBank([
  wordUk('ants', 'ants', 'uk_murakhy', 'мурахи', 'му-ра-хи'),
  wordUk('fish', 'fish', 'uk_ryba', 'риба', 'ри-ба'),
  wordUk('cow', 'cow', 'uk_korova', 'корова', 'ко-ро-ва'),
  wordUk('buddy', null, null, 'чоловіче', null),
  wordUk('bark', 'bark.jpg', 'uk_kora', 'кора', 'ко-ра'),
  wordUk('guitar', 'guitar', 'uk_hitara', 'гітара', 'гі-та-ра'),
  wordUk('frame', 'frame.jpg', 'uk_rama', 'рама', 'ра-ма'),
]);

abstract final class MatchingSyllablesGeneratorDemo {
  static final Topic topic = Topic(
    id: 'matching_syllables',
    taskTypeCounts: {LearningTaskType.matching: 1},
    taskOrderMode: TaskOrderMode.deterministic,
    dataSource: CompositeTaskDataSource([
      GeneratedTaskDataSource([
        SyllableMatchingTaskDataGenerator(
          bank: syllableDemoBank,
          taskCount: 2,
          pairCount: 3,
          filter: WordFilter(
            syllablePattern: 'ра',
            position: SyllableSearchPosition.any,
          ),
          language: Language.uk,

          leftColumnElement: MatchingColumnElement.image,
          leftColumnAudio: MatchingColumnAudio.word,

          rightColumnElement: MatchingColumnElement.syllable,
          rightColumnAudio: MatchingColumnAudio.syllable,

          textCase: MatchingTextCase.uppercase,
          syllableAudio: syllableAudioUk,
          swapColumns: true,
          buttonConfig: MatchingButtonConfig(
            fontSize: 20,
            buttonWidth: 160,
            buttonHeight: 120,
            spacing: 8,
            lightBackgroundColor: const Color(0xFFE0E0E0),
            darkBackgroundColor: const Color(0xFF424242),
          ),
        ),
      ]),
    ]),
    help: 'Зістав пари',
    evaluation: EvaluationConfig(
      weights: {
        EvaluationCriterionType.accuracy: 1,
        EvaluationCriterionType.time: 1,
      },
      time: TimeEvaluationConfig(
        targetTime: Duration(seconds: 15),
        maximumTime: Duration(seconds: 300),
      ),
    ),
    passingCriteria: PassingCriteria(minimumAccuracy: 0.1),
    layout: TopicLayout.minimalPrompt(),
    progressionMode: TopicProgressionMode.automaticWithFeedback,
    feedbackDuration: Duration(milliseconds: 1000),
    automaticTermination: AutomaticTerminationConfig(
      failureLimit: 4,
      countdown: Duration(seconds: 60, milliseconds: 0),
      pauseOnExitDialog: true,
    ),
    dashboard: DashboardConfig(
      showProgress: true,
      showTimer: true,
      showRemainingAttempts: true,
    ),
  );
}
