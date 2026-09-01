import 'package:school_tasks/features/learning/data/fixed_task_data/addition.dart';
import 'package:school_tasks/features/learning/data/generation/generated_task_data_source.dart';
import 'package:school_tasks/features/learning/data/generation/multiplication/multiplication_data_generator.dart';
import 'package:school_tasks/features/learning/data/generation/multiplication/multiplication_generator_config.dart';
import 'package:school_tasks/features/learning/data/generation/multiplication/multiplication_prompt_type.dart';
import 'package:school_tasks/features/learning/data/generation/wrong_answer_generator.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/passing_criteria.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/fixed_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';

abstract final class AdditionWithin10 {
  static final Topic topic = Topic(
    id: 'addition_within_10',
    taskTypeCounts: {
      LearningTaskType.selection: 2,
      // LearningTaskType.numericInput: 2,
    },
    dataSource: GeneratedTaskDataSource(
      MultiplicationTaskDataGenerator(
        config: MultiplicationGeneratorConfig(
          minA: 2,
          maxA: 9,
          minB: 3,
          maxB: 9,
          minimumResult: 6,
          maximumResult: 40,
          wrongAnswerMinimumResult: 11,
          wrongAnswerMaximumResult: 45,
          wrongAnswerStrategy: WrongAnswerStrategy.randomInRange,
          wrongAnswerCount: 3,
          divisibilityA: 1,
          resultDivisibility: 1,
          wrongAnswerDivisibility: 1,
        ),
        promptType: MultiplicationPromptType.grid,
        gridItem: ImageContent('assets/images/tasks/square.png'),
      ),
    ),
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
  //TODO remove or replace later this object of Topic:
  static final Topic topic_postponed = Topic(
    id: 'addition_within_10',
    taskTypeCounts: {
      LearningTaskType.selection: 2,
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
