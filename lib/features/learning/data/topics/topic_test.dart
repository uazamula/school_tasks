import 'package:school_tasks/features/learning/data/fixed_task_data/addition.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/algebraic_operations.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/fraction_data.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/geometry_shapes.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/matching_data.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/multiplication.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/position_selection.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/passing_criteria.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/fixed_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/interaction_layout.dart';
import 'package:school_tasks/features/learning/domain/prompt_layout.dart';
import 'package:school_tasks/features/learning/domain/task_navigation_mode.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_layout.dart';

abstract final class Tests {
  static final Topic topic = Topic(
    id: 'shapes',
    taskTypeCounts: {
      LearningTaskType.matching: 1,
      LearningTaskType.positionSelection: 1,
      LearningTaskType.numericInput: 1,
      LearningTaskType.selection: 1,
      LearningTaskType.fraction: 3,
    },
    dataSource: FixedTaskDataSource([
      // ...GeometryShapesData.simpleShapes,
      ...GeometryShapesData.shapes,
      ...matchingTasks,
      ...matchingTasks,
      ...positionSelectionTasks,
      ...FractionData.fractions,
      // ...AdditionTaskData.within10,
      ...MultiplicationTaskData.multiplicationTable,
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
      prompt: PromptLayout(scrollable: true),
      interaction: InteractionLayout(scrollable: true),
    ),
    navigationMode: TaskNavigationMode.manual,
  );
}
