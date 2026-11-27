import 'package:school_tasks/features/learning/data/fixed_task_data/fixed_data_position_selection.dart';
import 'package:school_tasks/features/learning/domain/automatic_termination_config.dart';
import 'package:school_tasks/features/learning/domain/composite_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/dashboard_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/passing_criteria.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/fixed_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/interaction_layout.dart';
import 'package:school_tasks/features/learning/domain/prompt_layout.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_order_mode.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_area_order.dart';
import 'package:school_tasks/features/learning/domain/topic_layout.dart';
import 'package:school_tasks/features/learning/domain/topic_progression_mode.dart';

abstract final class Tests {
  static final Topic topic = Topic(
    id: 'shapes',
    taskTypeCounts: {LearningTaskType.slotAssembly: 1},
    taskOrderMode: TaskOrderMode.deterministic,
    dataSource: CompositeTaskDataSource([
      FixedTaskDataSource([...positionSelectionTasks]),
    ]),
    help: 'Тестування різних типів завдань',

    evaluation: EvaluationConfig(
      weights: {
        EvaluationCriterionType.accuracy: 1,
        EvaluationCriterionType.time: 0,
      },
      time: TimeEvaluationConfig(
        targetTime: Duration(seconds: 15),
        maximumTime: Duration(seconds: 300),
      ),
    ),
    passingCriteria: PassingCriteria(
      minimumAccuracy: 0.6,
      maximumTime: Duration(seconds: 15),
      maximumFailures: 1,
    ),
    layout: TopicLayout(
      promptFlex: 1,
      interactionFlex: 4,
      prompt: PromptLayout(scrollable: false),
      interaction: InteractionLayout(scrollable: false),
      areaOrder: TopicAreaOrder.promptFirst,
    ),
    progressionMode: TopicProgressionMode.automaticWithFeedback,
    feedbackDuration: Duration(milliseconds: 1000),
    automaticTermination: AutomaticTerminationConfig(
      failureLimit: 4,
      countdown: Duration(seconds: 10, milliseconds: 0),
      pauseOnExitDialog: true,
    ),
    dashboard: DashboardConfig(
      showProgress: true,
      showTimer: true,
      showRemainingAttempts: true,
      showStreak: false,
    ),
  );
}
