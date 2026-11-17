import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/fixed_data_matching.dart';
import 'package:school_tasks/features/learning/data/generation/generated_task_data_source.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/matching_text_case.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/syllable_matching_task_data_generator.dart';
import 'package:school_tasks/features/learning/data/word_content/syllable_audio_uk.dart';
import 'package:school_tasks/features/learning/data/word_content/word_bank.dart';
import 'package:school_tasks/features/learning/domain/automatic_termination_config.dart';
import 'package:school_tasks/features/learning/domain/composite_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/dashboard_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/passing_criteria.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/fixed_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/interaction_layout.dart';
import 'package:school_tasks/features/learning/domain/prompt_layout.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_button_config.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_order_mode.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_area_order.dart';
import 'package:school_tasks/features/learning/domain/topic_layout.dart';
import 'package:school_tasks/features/learning/domain/topic_progression_mode.dart';
import 'package:school_tasks/features/learning/domain/word_content/language.dart';
import 'package:school_tasks/features/learning/domain/word_content/syllable_search_position.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_filter.dart';

abstract final class Tests {
  static final Topic topic = Topic(
    id: 'shapes',
    taskTypeCounts: {
      LearningTaskType.slotAssembly: 1,
    },
    taskOrderMode: TaskOrderMode.deterministic,
    dataSource: CompositeTaskDataSource([
      GeneratedTaskDataSource([
        SyllableMatchingTaskDataGenerator(
          bank: ukWordBank,
          taskCount: 1,
          pairCount: 2,
          filter: WordFilter(
            syllablePattern: '*р*',
            position: SyllableSearchPosition.any,
          ),
          language: Language.uk,
          textCase: MatchingTextCase.title,
          syllableAudio: syllableAudioUk,
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

      FixedTaskDataSource([
        ...matchingTasks,
      ]),
    ]),
    help: 'Тестування різних типів завдань',

    evaluation: EvaluationConfig(
      weights: {
        EvaluationCriterionType.accuracy: 1,
        EvaluationCriterionType.time: 0,
      },
      time: TimeEvaluationConfig(
        targetTime: Duration(seconds: 15),
        maximumTime: Duration(seconds: 300),
      ),
    ),
    passingCriteria: PassingCriteria(
      minimumAccuracy: 0.6,
      maximumTime: Duration(seconds: 15),
      maximumFailures: 1,
    ),
    layout: TopicLayout(
      promptFlex: 1,
      interactionFlex: 4,
      prompt: PromptLayout(scrollable: false),
      interaction: InteractionLayout(scrollable: false),
      areaOrder: TopicAreaOrder.promptFirst,
    ),
    progressionMode: TopicProgressionMode.automaticWithFeedback,
    feedbackDuration: Duration(milliseconds: 1000),
    automaticTermination: AutomaticTerminationConfig(
      failureLimit: 4,
      countdown: Duration(seconds: 10, milliseconds: 0),
      pauseOnExitDialog: true,
    ),
    dashboard: DashboardConfig(
      showProgress: true,
      showTimer: true,
      showRemainingAttempts: true,
      showStreak: false,
    ),
  );
}
