import 'package:school_tasks/features/learning/data/fixed_task_data/fixed_data_addition.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/fixed_data_fraction.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/fixed_data_geometry_shapes.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/fixed_data_matching.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/fixed_data_position_selection.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/fixed_data_rational.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/passing_criteria.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/fixed_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/interaction_layout.dart';
import 'package:school_tasks/features/learning/domain/prompt_layout.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_layout.dart';
import 'package:school_tasks/features/learning/domain/topic_progression_mode.dart';

abstract final class Tests {
  static final Topic topic = Topic(
    id: 'shapes',
    taskTypeCounts: {
      LearningTaskType.matching: 0,
      LearningTaskType.positionSelection: 0,
      LearningTaskType.input: 4,
      LearningTaskType.selection: 0,
      LearningTaskType.fraction: 0,
    },
    dataSource: FixedTaskDataSource([
      // ...GeometryShapesData.simpleShapes,
      ...GeometryShapesData.shapes,
      ...matchingTasks,
      // ...additionWithSound,
      // ...matchingTasks,
      ...positionSelectionTasks,
      ...FractionData.fractions,
      // ...AdditionTaskData.within10,
      ...rational,
      // ...MultiplicationTaskData.multiplicationTable,
      // ...OperationsTaskData.simpleOperations,
    ]),
    help: 'Тестування різних типів завдань',
    evaluation: EvaluationConfig(
      weights: {
        EvaluationCriterionType.accuracy: 1,
        EvaluationCriterionType.time: 0,
      },
      time: TimeEvaluationConfig(
        targetTime: Duration(seconds: 30),
        maximumTime: Duration(seconds: 90),
      ),
    ),
    passingCriteria: PassingCriteria(minimumAccuracy: 0.2),
    layout: TopicLayout(
      promptFlex: 1,
      interactionFlex: 1,
      prompt: PromptLayout(scrollable: false),
      interaction: InteractionLayout(scrollable: false),
    ),
    progressionMode: TopicProgressionMode.automatic,
    feedbackDuration: Duration(milliseconds: 500),
  );
}
