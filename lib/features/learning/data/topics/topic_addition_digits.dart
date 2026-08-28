import 'package:school_tasks/features/learning/data/task_data/addition.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/fixed_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';

abstract final class AdditionDigits {
  static const Topic topic = Topic(
    id: 'addition_digits',
    taskTypeCounts: {LearningTaskType.choice: 2},
    dataSource: FixedTaskDataSource(AdditionTaskData.additionDigits),
    help: 'Тут буде довідка про додавання одноцифрових чисел.',
    evaluation: EvaluationConfig(
      weights: {
        EvaluationCriterionType.accuracy: 1.0,
        EvaluationCriterionType.time: 0,
      },
    ),
  );
}
