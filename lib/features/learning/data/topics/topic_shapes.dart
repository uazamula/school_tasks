import 'package:school_tasks/features/learning/data/task_data/addition.dart';
import 'package:school_tasks/features/learning/data/task_data/geometry_shapes.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/fixed_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';

abstract final class Shapes {
  static const Topic topic = Topic(
    id: 'shapes',
    taskTypeCounts: {
      LearningTaskType.multiChoice: 1,
      LearningTaskType.choice: 1,
    },
    dataSource: FixedTaskDataSource([
      ...GeometryShapesData.simpleShapes,
      ...AdditionTaskData.within10,
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
  );
}
