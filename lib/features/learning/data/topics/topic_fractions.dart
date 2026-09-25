import 'package:school_tasks/features/learning/data/fixed_task_data/fixed_data_fraction.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/fixed_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_progression_mode.dart';

abstract final class Fractions {
  static final Topic topic = Topic(
    id: 'fractions',
    taskTypeCounts: {
      LearningTaskType.matching: 0,
      LearningTaskType.positionSelection: 0,
      LearningTaskType.input: 0,
      LearningTaskType.selection: 0,
      LearningTaskType.fraction: 10,
    },
    dataSource: FixedTaskDataSource([...FractionData.fractions]),
    help: 'Тестування різних типів завдань',
    evaluation: EvaluationConfig(
      weights: {
        EvaluationCriterionType.accuracy: 1,
        EvaluationCriterionType.time: 0,
      },
    ),
    progressionMode: TopicProgressionMode.automaticWithFeedback,
  );
}
