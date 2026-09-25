import 'package:school_tasks/features/learning/data/generation/arithmetic/arithmetic_generator_config.dart';
import 'package:school_tasks/features/learning/data/generation/arithmetic/arithmetic_operation.dart';
import 'package:school_tasks/features/learning/data/generation/arithmetic/arithmetic_task_data_generator.dart';
import 'package:school_tasks/features/learning/data/generation/generated_task_data_source.dart';
import 'package:school_tasks/features/learning/data/generation/wrong_answer_generator.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/passing_criteria.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';

abstract final class MultiplicationTableSelected {
  static final Topic topic = Topic(
    id: 'multiplication_table_selected',
    taskTypeCounts: {LearningTaskType.selection: 10},
    dataSource: GeneratedTaskDataSource([
      ArithmeticTaskDataGenerator(
        operation: ArithmeticOperation.multiplication,
        imageForGrid: 'assets/images/tasks/apple.png',
        config: ArithmeticGeneratorConfig(
          minA: 3,
          maxA: 6,
          minB: 3,
          maxB: 9,
          minimumResult: 12,
          maximumResult: 81,
          wrongAnswerMinimumResult: 14,
          wrongAnswerMaximumResult: 81,
          wrongAnswerStrategy: WrongAnswerStrategy.randomInRange,
          wrongAnswerCount: 4,
          divisibilityA: 1,
          resultDivisibility: 1,
          wrongAnswerDivisibility: 1,
        ),
      ),
    ]),
    help: 'Тут буде довідка про множення.',
    evaluation: EvaluationConfig(
      weights: {
        EvaluationCriterionType.accuracy: 7,
        EvaluationCriterionType.time: 3,
      },
      time: TimeEvaluationConfig(
        targetTime: Duration(seconds: 20),
        maximumTime: Duration(seconds: 40),
      ),
    ),
    passingCriteria: PassingCriteria(maximumTime: Duration(seconds: 60)),
  );
}
