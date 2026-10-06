import 'package:school_tasks/features/learning/data/fixed_task_data/inf/coding/coding.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/passing_criteria.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/fixed_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/interaction_layout.dart';
import 'package:school_tasks/features/learning/domain/prompt_layout.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_layout.dart';
import 'package:school_tasks/features/learning/domain/topic_progression_mode.dart';

abstract final class TopicCoding {
  static final Topic topicCoding = Topic(
    id: 'coding1',
    taskTypeCounts: {
      LearningTaskType.matching: 0,
      LearningTaskType.positionSelection: 0,
      LearningTaskType.input: 5,
      LearningTaskType.selection: 5,
      LearningTaskType.fraction: 0,
    },
    dataSource: FixedTaskDataSource([
      ...CodingTasks.codingTasksInput,
      ...CodingTasks.codingTasksSel,
    ]),
    help: 'Тестування різних типів завдань',
    evaluation: EvaluationConfig(
      weights: {
        EvaluationCriterionType.accuracy: 1,
        EvaluationCriterionType.time: 1,
      },
      time: TimeEvaluationConfig(
        targetTime: Duration(seconds: 60),
        maximumTime: Duration(seconds: 90),
      ),
    ),
    passingCriteria: PassingCriteria(
      minimumAccuracy: 0.5,
      maximumTime: Duration(seconds: 120),
    ),
    layout: TopicLayout(
      promptFlex: 1,
      interactionFlex: 2,
      prompt: PromptLayout(scrollable: false),
      interaction: InteractionLayout(scrollable: false),
    ),
    progressionMode: TopicProgressionMode.automatic,
    feedbackDuration: Duration(milliseconds: 300),
  );
}
