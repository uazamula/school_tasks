import 'package:school_tasks/features/learning/data/fixed_task_data/addition.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/passing_criteria.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/fixed_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';

abstract final class AdditionWithin10 {
  static final Topic topic = Topic(
    id: 'addition_within_10',
    taskTypeCounts: {
      LearningTaskType.singleChoice: 2,
      LearningTaskType.numericInput: 2,
    },
    dataSource: FixedTaskDataSource(AdditionTaskData.within10),
    help: 'Тут буде довідка про додавання в межах 10.',
    evaluation: EvaluationConfig(
      weights: {
        EvaluationCriterionType.accuracy: 7,
        EvaluationCriterionType.time: 3,
      },
      time: TimeEvaluationConfig(
        targetTime: Duration(seconds: 5),
        maximumTime: Duration(seconds: 20),
      ),
    ),
    passingCriteria: PassingCriteria(minimumAccuracy: 0.0),
  );
}
