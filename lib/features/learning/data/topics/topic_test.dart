import 'dart:ui';

import 'package:school_tasks/features/learning/data/fixed_task_data/fixed_data_addition.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/fixed_data_fraction.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/fixed_data_geometry_shapes.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/fixed_data_matching.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/fixed_data_position_selection.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/fixed_data_rational.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/fixed_data_roots.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/inf/coding/coding.dart';
import 'package:school_tasks/features/learning/data/generation/arithmetic/arithmetic_generator_config.dart';
import 'package:school_tasks/features/learning/data/generation/arithmetic/arithmetic_operation.dart';
import 'package:school_tasks/features/learning/data/generation/arithmetic/arithmetic_task_data_generator.dart';
import 'package:school_tasks/features/learning/data/generation/generated_task_data_source.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/matching_column_element.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/syllable_matching_task_data_generator.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/word_matching_task_data_generation.dart';
import 'package:school_tasks/features/learning/data/generation/wrong_answer_generator.dart';
import 'package:school_tasks/features/learning/data/word_content/syllable_audio_uk.dart';
import 'package:school_tasks/features/learning/data/word_content/syllable_demo_data.dart';
import 'package:school_tasks/features/learning/data/word_content/word_matching_demo_data.dart';
import 'package:school_tasks/features/learning/domain/automatic_termination_config.dart';
import 'package:school_tasks/features/learning/domain/composite_task_data_source.dart';
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
import 'package:school_tasks/features/learning/domain/topic_layout.dart';
import 'package:school_tasks/features/learning/domain/topic_progression_mode.dart';
import 'package:school_tasks/features/learning/domain/word_content/language.dart';
import 'package:school_tasks/features/learning/domain/word_content/syllable_search_position.dart';

import '../fixed_task_data/fixed_data_audio.dart';

abstract final class Tests {
  static final Topic topic = Topic(
    id: 'shapes',
    taskTypeCounts: {
      LearningTaskType.matching: 1,
      LearningTaskType.positionSelection: 1,
      LearningTaskType.input: 0,
      LearningTaskType.selection: 0,
      LearningTaskType.fraction: 0,
    },
    taskOrderMode: TaskOrderMode.deterministic,
    dataSource: CompositeTaskDataSource([
      GeneratedTaskDataSource([
        SyllableMatchingTaskDataGenerator(
          words: syllableDemoWords,
          concepts: syllableDemoConcepts,
          language: Language.uk,
          syllablePattern: 'р?',
          position: SyllableSearchPosition.any,
          taskCount: 2,
          pairCount: 4,

          leftColumnElement:MatchingColumnElement.none,
          leftColumnAudio:MatchingColumnAudio.word,

          rightColumnElement:MatchingColumnElement.image,
          rightColumnAudio:MatchingColumnAudio.none,

          swapColumns: false,

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
        // ...GeometryShapesData.shapes,
        // ...CodingTasks.codingForTest,
        // ...CodingTasks.codingTasksSel,
        // ...matchingTasks,
        // ...additionWithSound,
        // ...matchingTasks,
        // ...positionSelectionTasks,
        // ...FractionData.fractions,
        // ...audioLinkedSelectionDemo,
        // ...roots,
        // ...audioLinkedPromptDemo,
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
        maximumTime: Duration(seconds: 30),
      ),
    ),
    passingCriteria: PassingCriteria(
      // minimumAccuracy: 0.6,
      // maximumTime: Duration(seconds: 15),
      // maximumFailures: 1,
    ),
    layout: TopicLayout(
      promptFlex: 2,
      interactionFlex: 3,
      prompt: PromptLayout(scrollable: false),
      interaction: InteractionLayout(scrollable: false),
    ),
    progressionMode: TopicProgressionMode.automatic,
    feedbackDuration: Duration(milliseconds: 300),
    automaticTermination: AutomaticTerminationConfig(
      // failureLimit: 2,
      // countdown: Duration(seconds: 25, milliseconds: 0),
    ),
  );
}
