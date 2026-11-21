import 'package:school_tasks/features/learning/data/generation/generated_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/automatic_termination_config.dart';
import 'package:school_tasks/features/learning/domain/composite_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/dashboard_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/passing_criteria.dart';
import 'package:school_tasks/features/learning/domain/fixed_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/task_data/selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_order_mode.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_progression_mode.dart';

abstract final class TopicAudioContentTest {
  static final Topic topic = Topic(
    id: 'test_audio_content',
    taskTypeCounts: {LearningTaskType.slotAssembly: 1},
    taskOrderMode: TaskOrderMode.deterministic,
    dataSource: CompositeTaskDataSource([
      GeneratedTaskDataSource([]),
      FixedTaskDataSource([
        SelectionTaskData(
          prompt: TaskPrompt(content: [TextContent('🍎🍎 + 🍎🍎🍎🍎🍎?')]),
          correctAnswers: [
            AudioContent.fixed('assets/audio/pronunciation/uk_sim.mp3'),
          ],
          wrongAnswers: [
            AudioContent.localized({
              'uk': 'assets/audio/pronunciation/uk_devjat.mp3',
              'tr': 'assets/audio/pronunciation/tr_dokuz.mp3',
            }),
            AudioContent.localized({
              'uk': 'assets/audio/pronunciation/uk_dva.mp3',
            }),
          ],
          wrongAnswerCount: 2,
          requiresConfirmation: true,
        ),
      ]),
    ]),
    evaluation: EvaluationConfig(
      weights: {
        EvaluationCriterionType.accuracy: 1,
        EvaluationCriterionType.time: 0,
      },
    ),
    passingCriteria: PassingCriteria(maximumFailures: 2),
    progressionMode: TopicProgressionMode.automaticWithFeedback,
    feedbackDuration: Duration(milliseconds: 500),
    automaticTermination: AutomaticTerminationConfig(pauseOnExitDialog: true),
    dashboard: DashboardConfig(showRemainingAttempts: true),
    help: 'Тестування audio',
    helpAudio: AudioContent.localized({
      'uk': 'assets/audio/help/uk_test_audio.mp3',
    }),
    helpAudioAutoplay: true,
    pauseTimerOnHelpAudio: false,
  );
}
