import 'package:school_tasks/core/theme/app_text_styles.dart';
import 'package:school_tasks/features/learning/domain/automatic_termination_config.dart';
import 'package:school_tasks/features/learning/domain/dashboard_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/passing_criteria.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/fixed_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/task_data/memory_board_mode.dart';
import 'package:school_tasks/features/learning/domain/task_data/memory_card_style_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/memory_grid_size.dart';
import 'package:school_tasks/features/learning/domain/task_data/memory_task_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/memory_task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/memory_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_order_mode.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_layout.dart';
import 'package:school_tasks/features/learning/domain/topic_progression_mode.dart';
import 'package:school_tasks/features/learning/domain/topic_result_kind.dart';

MemoryPair _pair(String id, String image, String word, String audio) {
  return MemoryPair(
    id: id,
    hiddenContent: ImageContent(
      'assets/images/$image',
      audio: AudioContent.fixed('assets/audio/pronunciation/$audio.mp3'),
    ),
    faceFront: TextContent(word),
    faceBack: ImageContent('assets/images/$image'),
  );
}

final List<MemoryPair> _demoPairs = [
  _pair('crown', 'crown.png', 'корона', 'uk_korona'),
  _pair('ants', 'ants.png', 'мурахи', 'uk_murakhy'),
  _pair('apron', 'apron.png', 'фартух', 'uk_fartukh'),
  _pair('arc', 'arc.png', 'арка', 'uk_arka'),
  _pair('dew', 'dew.png', 'роса', 'uk_rosa'),
  _pair('frame', 'frame.jpg', 'рама', 'uk_rama'),
];

TaskPrompt _prompt(String text) => TaskPrompt(content: [TextContent(text)]);

abstract final class MemoryFiniteDemo {
  static final Topic topic = Topic(
    id: 'memory_finite',
    taskTypeCounts: {LearningTaskType.memory: 1},
    taskOrderMode: TaskOrderMode.deterministic,
    dataSource: FixedTaskDataSource([
      MemoryTaskData(
        prompt: _prompt('Знайди пару'),
        pairPool: _demoPairs,
        config: const MemoryTaskConfig(
          gridSize: MemoryGridSize.size3x4,
          replayAudioOnMatch: true,
          cardAspectRatio: 1,
          cardStyle: MemoryCardStyleConfig(
            front: MemoryFaceStyle(textStyle: AppTextStyles.headline),
          ),
        ),
      ),
    ]),
    help: 'Memory: скінченна дошка',
    evaluation: const EvaluationConfig(
      weights: {
        EvaluationCriterionType.accuracy: 1,
        EvaluationCriterionType.time: 1,
      },
      time: TimeEvaluationConfig(
        targetTime: Duration(seconds: 20),
        maximumTime: Duration(seconds: 120),
      ),
    ),
    progressionMode: TopicProgressionMode.automaticWithFeedback,
    automaticTermination: const AutomaticTerminationConfig(failureLimit: 5),
    dashboard: const DashboardConfig(showRemainingAttempts: true),
    layout: const TopicLayout.minimalPrompt(),
  );
}

abstract final class MemoryEndlessDemo {
  static final Topic topic = Topic(
    id: 'memory_endless',
    taskTypeCounts: {LearningTaskType.memory: 1},
    taskOrderMode: TaskOrderMode.deterministic,
    dataSource: FixedTaskDataSource([
      MemoryTaskData(
        prompt: _prompt('Знайди пару'),
        pairPool: _demoPairs,
        mode: const EndlessMemoryMode(failedPairWeight: 3),
        config: const MemoryTaskConfig(
          gridSize: MemoryGridSize.size2x2,
          peekDuration: Duration(seconds: 5),
        ),
      ),
    ]),
    help: 'Memory: нескінченна гра, рахується найкраща серія',
    evaluation: const EvaluationConfig(weights: {}),
    resultKind: TopicResultKind.streak,
    progressionMode: TopicProgressionMode.automaticWithFeedback,
    automaticTermination: const AutomaticTerminationConfig(
      failureLimit: 3,
      countdown: Duration(minutes: 2),
      pauseOnExitDialog: false,
    ),
    dashboard: const DashboardConfig(
      showProgress: false,
      showTimer: true,
      showRemainingAttempts: true,
      showStreak: true,
    ),
    layout: const TopicLayout.minimalPrompt(),
  );
}

abstract final class MemoryGoalDemo {
  static final Topic topic = Topic(
    id: 'memory_goal',
    taskTypeCounts: {LearningTaskType.memory: 1},
    taskOrderMode: TaskOrderMode.deterministic,
    dataSource: FixedTaskDataSource([
      MemoryTaskData(
        prompt: _prompt('Склади 8 пар'),
        pairPool: _demoPairs,
        mode: const EndlessMemoryMode(
          targetStreak: 8,
          failedPairWeight: 3,
          continueAfterGoal: true,
        ),
        config: const MemoryTaskConfig(
          gridSize: MemoryGridSize.size2x2,
          peekDuration: Duration(seconds: 5),
          separatedZones: false,
        ),
      ),
    ]),
    help: 'Memory: досягни серії 8 підряд',
    evaluation: const EvaluationConfig(
      weights: {
        EvaluationCriterionType.accuracy: 1,
        EvaluationCriterionType.time: 1,
      },
      time: TimeEvaluationConfig(
        targetTime: Duration(seconds: 40),
        maximumTime: Duration(seconds: 180),
      ),
    ),
    passingCriteria: const PassingCriteria(minimumAccuracy: 1.0),
    layout: const TopicLayout.minimalPrompt(),
    progressionMode: TopicProgressionMode.automaticWithFeedback,
    automaticTermination: const AutomaticTerminationConfig(failureLimit: 3),
    dashboard: const DashboardConfig(
      showTimer: true,
      showStreak: true,
      showRemainingAttempts: true,
    ),
    resultKind: TopicResultKind.grade,
  );
}
