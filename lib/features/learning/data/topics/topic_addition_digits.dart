import 'package:school_tasks/features/learning/data/fixed_task_data/fraction_data.dart';
import 'package:school_tasks/features/learning/data/generation/arithmetic/arithmetic_generator_config.dart';
import 'package:school_tasks/features/learning/data/generation/arithmetic/arithmetic_operation.dart';
import 'package:school_tasks/features/learning/data/generation/arithmetic/arithmetic_task_data_generator.dart';
import 'package:school_tasks/features/learning/data/generation/generated_task_data_source.dart';
import 'package:school_tasks/features/learning/data/generation/wrong_answer_generator.dart';
import 'package:school_tasks/features/learning/domain/composite_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/fixed_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';

abstract final class AdditionDigits {
  static final Topic topic = Topic(
    id: 'addition_digits',
    taskTypeCounts: {
      LearningTaskType.numericInput: 3,
      LearningTaskType.selection: 1,
      LearningTaskType.fraction: 1,
    },
    dataSource: CompositeTaskDataSource([
      FixedTaskDataSource([...FractionData.fractions]),
      GeneratedTaskDataSource([
        ArithmeticTaskDataGenerator(
          operation: ArithmeticOperation.multiplication,
          // imageForGrid: 'assets/images/tasks/square.png',
          useNumericInput: false,
          config: ArithmeticGeneratorConfig(
            minA: 1,
            maxA: 9,
            minB: 1,
            maxB: 9,
            minimumResult: 7,
            maximumResult: 40,
            wrongAnswerMinimumResult: 4,
            wrongAnswerMaximumResult: 29,
            wrongAnswerStrategy: WrongAnswerStrategy.randomInRange,
            wrongAnswerCount: 4,
            divisibilityA: 2,
            resultDivisibility: 3,
            wrongAnswerDivisibility: 2,
          ),
        ),
        ArithmeticTaskDataGenerator(
          operation: ArithmeticOperation.multiplication,
          imageForGrid: 'assets/images/tasks/apple.png',
          useNumericInput: true,
          config: ArithmeticGeneratorConfig(
            minA: 1,
            maxA: 9,
            minB: 1,
            maxB: 9,
            minimumResult: 2,
            maximumResult: 40,
            wrongAnswerMinimumResult: 4,
            wrongAnswerMaximumResult: 39,
            wrongAnswerStrategy: WrongAnswerStrategy.randomInRange,
            wrongAnswerCount: 4,
            divisibilityA: 1,
            resultDivisibility: 1,
            wrongAnswerDivisibility: 2,
          ),
        ),
      ]),
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
