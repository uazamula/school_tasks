import 'package:school_tasks/features/learning/data/fixed_task_data/multiplication.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/passing_criteria.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/fixed_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';

abstract final class MultiplicationTable {
  static final Topic topic = Topic(
    id: 'multiplication_table',
    taskTypeCounts: {
      LearningTaskType.selection: 2,
      LearningTaskType.numericInput: 1,
    },
    dataSource: FixedTaskDataSource(MultiplicationTaskData.multiplicationTable),
    help: 'Тут буде довідка про множення.',
    evaluation: EvaluationConfig(
      weights: {
        EvaluationCriterionType.accuracy: 7,
        EvaluationCriterionType.time: 3,
      },
      time: TimeEvaluationConfig(
        targetTime: Duration(seconds: 10),
        maximumTime: Duration(seconds: 20),
      ),
    ),
    passingCriteria: PassingCriteria(minimumAccuracy: 0.0),
  );
}
