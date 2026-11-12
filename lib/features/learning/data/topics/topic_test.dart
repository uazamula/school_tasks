import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/fixed_data_matching.dart';
import 'package:school_tasks/features/learning/data/generation/generated_task_data_source.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/matching_column_element.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/matching_text_case.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/slot_assembly_task_data_generator.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/syllable_matching_task_data_generator.dart';
import 'package:school_tasks/features/learning/data/word_content/syllable_audio_uk.dart';
import 'package:school_tasks/features/learning/data/word_content/syllable_demo_data.dart';
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
import 'package:school_tasks/features/learning/domain/task_data/slot_assembly_ui_config.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/target_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/slot_assembly_interaction_mode.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_order_mode.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_area_order.dart';
import 'package:school_tasks/features/learning/domain/topic_layout.dart';
import 'package:school_tasks/features/learning/domain/topic_progression_mode.dart';
import 'package:school_tasks/features/learning/domain/word_content/content_tag.dart';
import 'package:school_tasks/features/learning/domain/word_content/int_range.dart';
import 'package:school_tasks/features/learning/domain/word_content/language.dart';
import 'package:school_tasks/features/learning/domain/word_content/syllable_search_position.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_bank.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_builder.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_filter.dart';

abstract final class Tests {
  static final Topic topic = Topic(
    id: 'shapes',
    taskTypeCounts: {
      LearningTaskType.matching: 1,
      LearningTaskType.positionSelection: 0,
      LearningTaskType.input: 0,
      LearningTaskType.selection: 0,
      LearningTaskType.fraction: 0,
      LearningTaskType.slotAssembly: 1,
    },
    taskOrderMode: TaskOrderMode.deterministic,
    dataSource: CompositeTaskDataSource([
      GeneratedTaskDataSource([
        SlotAssemblyTaskDataGenerator(
          bank: WordBank.fromLegacy(
            words: syllableDemoWords,
            concepts: syllableDemoConcepts,
          ),
          taskCount: 1,
          wrongAnswerCount: 3,
          filter: WordFilter(
            syllablePattern: '*р*',
            position: SyllableSearchPosition.any,
            tagsAnyOf: {ContentTag.animal},
            syllableCount: IntRange(min: 2, max: 3),
          ),
          targetType: SlotAssemblyTargetType.wordWithAudio,
          language: Language.uk,
          distractorMode: SlotAssemblyDistractorMode.similarToCorrect,
          requireSyllableAudio: false,

          promptContent: [TextContent('Склади слово, натискаючи на склади')],
          targetFontSize: 42,
          targetEffect: const TargetEffectConfig(
            type: TargetEffectType.outlineFill,
            outline: OutlineFillConfig(
              mode: OutlineFillMode.all,
              finalFlash: true,
              // null — колір заливки
              flashColor: Colors.amber,
              flashDuration: Duration(milliseconds: 700),
              flashStrength: 1.3,
              flashScale: 0.08,
            ),
          ),
          textCase: MatchingTextCase.uppercase,
          syllableAudio: syllableAudioUk,
          syllableHasSound: true,
          requiresSequentialSelection: true,
          interactionMode: PressForSlotInteractionMode(
            flightAnimationEnabled: true,
            fallingElementsEnabled: true,
          ),
          uiConfig: SlotAssemblyUiConfig(showSlotHints: true),
        ),
        SyllableMatchingTaskDataGenerator(
          bank: ukWordBank,
          taskCount: 1,
          pairCount: 2,
          filter: WordFilter(
            syllablePattern: '*р*',
            position: SyllableSearchPosition.any,
          ),
          language: Language.uk,

          leftColumnElement: MatchingColumnElement.image,
          leftColumnAudio: MatchingColumnAudio.word,

          rightColumnElement: MatchingColumnElement.none,
          rightColumnAudio: MatchingColumnAudio.syllable,

          swapColumns: false,
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
      // GeneratedTaskDataSource([
      //   ArithmeticTaskDataGenerator(
      //     operation: ArithmeticOperation.multiplication,
      //     // imageForGrid: 'assets/images/tasks/square.png',
      //     inputMode: null,
      //     config: ArithmeticGeneratorConfig(
      //       minA: 4,
      //       maxA: 9,
      //       minB: 1,
      //       maxB: 9,
      //       minimumResult: 7,
      //       maximumResult: 40,
      //       wrongAnswerMinimumResult: 4,
      //       wrongAnswerMaximumResult: 29,
      //       wrongAnswerStrategy: WrongAnswerStrategy.randomInRange,
      //       wrongAnswerCount: 4,
      //       divisibilityA: 2,
      //       resultDivisibility: 3,
      //       wrongAnswerDivisibility: 2,
      //     ),
      //   ),
      // ]),
      FixedTaskDataSource([
        // ...GeometryShapesData.simpleShapes,
        // ...slotAssemblyWord,

        // ...GeometryShapesData.shapes,
        // ...CodingTasks.codingForTest,
        // ...CodingTasks.codingTasksSel,
        ...matchingTasks,
        // ...additionWithSound,
        // ...matchingTasks,
        // ...positionSelectionTasks,
        // ...FractionData.fractions,
        // ...audioSelectionDemo,
        // ...roots,
        // ...audioPromptDemo,
        // ...AdditionTaskData.within10,
        // ...rational,
        // ...MultiplicationTaskData.multiplicationTable,
        // ...OperationsTaskData.simpleOperations,
      ]),
    ]),
    help: 'Тестування різних типів завдань',

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
    passingCriteria: PassingCriteria(
      // minimumAccuracy: 0.6,
      // maximumTime: Duration(seconds: 15),
      // maximumFailures: 1,
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
      countdown: Duration(seconds: 60, milliseconds: 0),
    ),
    dashboard: DashboardConfig(
      showProgress: true,
      showTimer: true,
      showRemainingAttempts: true,
    ),
  );
}
