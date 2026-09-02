import 'package:school_tasks/features/learning/data/generation/arithmetic/arithmetic_generator_config.dart';
import 'package:school_tasks/features/learning/data/generation/arithmetic/arithmetic_operation.dart';
import 'package:school_tasks/features/learning/data/generation/arithmetic/arithmetic_task_data_generator.dart';
import 'package:school_tasks/features/learning/data/generation/generated_task_data_source.dart';
import 'package:school_tasks/features/learning/data/generation/wrong_answer_generator.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';

abstract final class AdditionDigits {
  static final Topic topic = Topic(
    id: 'addition_digits',
    taskTypeCounts: {
      LearningTaskType.numericInput: 2,
      LearningTaskType.selection: 2,
    },
    dataSource: GeneratedTaskDataSource([
      ArithmeticTaskDataGenerator(
        operation: ArithmeticOperation.multiplication,
        // imageForGrid: 'assets/images/tasks/square.png',
        useNumericInput: false,
        config: ArithmeticGeneratorConfig(
          minA: 1,
          maxA: 9,
          minB: 1,
          maxB: 9,
          minimumResult: 2,
          maximumResult: 18,
          wrongAnswerMinimumResult: 4,
          wrongAnswerMaximumResult: 19,
          wrongAnswerStrategy: WrongAnswerStrategy.randomInRange,
          wrongAnswerCount: 4,
          divisibilityA: 2,
          resultDivisibility: 3,
          wrongAnswerDivisibility: 2,
        ),
      ),
      ArithmeticTaskDataGenerator(
        operation: ArithmeticOperation.multiplication,
        imageForGrid: 'assets/images/tasks/square.png',
        useNumericInput: true,
        config: ArithmeticGeneratorConfig(
          minA: 1,
          maxA: 9,
          minB: 1,
          maxB: 9,
          minimumResult: 2,
          maximumResult: 18,
          wrongAnswerMinimumResult: 4,
          wrongAnswerMaximumResult: 19,
          wrongAnswerStrategy: WrongAnswerStrategy.randomInRange,
          wrongAnswerCount: 4,
          divisibilityA: 2,
          resultDivisibility: 3,
          wrongAnswerDivisibility: 2,
        ),
      ),
    ]),
    help: 'Тут буде довідка про додавання одноцифрових чисел.',
    evaluation: EvaluationConfig(
      weights: {
        EvaluationCriterionType.accuracy: 1.0,
        EvaluationCriterionType.time: 0,
      },
    ),
  );
}
