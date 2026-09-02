import 'package:school_tasks/features/learning/data/fixed_task_data/addition.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/algebraic_operations.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/geometry_shapes.dart';
import 'package:school_tasks/features/learning/data/fixed_task_data/multiplication.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/passing_criteria.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/fixed_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';

abstract final class Shapes {
  static final Topic topic = Topic(
    id: 'shapes',
    taskTypeCounts: {LearningTaskType.selection: 3},
    dataSource: FixedTaskDataSource([
      ...GeometryShapesData.simpleShapes,
      // ...AdditionTaskData.within10,
      //   ...MultiplicationTaskData.multiplicationTable,
      ...OperationsTaskData.simpleOperations,
    ]),
    help: 'Розпізнавання геометричних фігур.',
    evaluation: EvaluationConfig(
      weights: {
        EvaluationCriterionType.accuracy: 7,
        EvaluationCriterionType.time: 3,
      },
      time: TimeEvaluationConfig(
        targetTime: Duration(seconds: 30),
        maximumTime: Duration(seconds: 90),
      ),
    ),
    passingCriteria: PassingCriteria(minimumAccuracy: 0.4),
  );
}
