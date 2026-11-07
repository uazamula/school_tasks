import 'package:school_tasks/features/learning/domain/automatic_termination_config.dart';
import 'package:school_tasks/features/learning/domain/dashboard_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/fixed_task_data_source.dart';
import 'package:school_tasks/features/learning/domain/task_data/memory_board_mode.dart';
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
import 'package:school_tasks/features/learning/domain/topic_progression_mode.dart';
import 'package:school_tasks/features/learning/domain/topic_result_kind.dart';

MemoryPair _pair(String id, String image, String word, String audio) {
  return MemoryPair(
    id: id,
    hiddenContent: ImageContent(
      'assets/images/$image.png',
      audio: AudioContent.fixed('assets/audio/pronunciation/$audio.mp3'),
    ),
    faceFront: TextContent(word),
    faceBack: ImageContent('assets/images/$image.png'),
  );
}

final List<MemoryPair> _demoPairs = [
  _pair('anchor', 'anchor', 'якір', 'uk_name1'),
  _pair('ants', 'ants', 'мурахи', 'uk_name2'),
  _pair('apron', 'apron', 'фартух', 'uk_name3'),
  _pair('arc', 'arc', 'дуга', 'uk_name4'),
];

const _prompt = TaskPrompt(content: [TextContent('Знайди пару')]);

abstract final class MemoryFiniteDemo {
  static final Topic topic = Topic(
    id: 'memory_finite',
    taskTypeCounts: {LearningTaskType.memory: 1},
    taskOrderMode: TaskOrderMode.deterministic,
    dataSource: FixedTaskDataSource([
      MemoryTaskData(
        prompt: _prompt,
        pairPool: _demoPairs,
        config: const MemoryTaskConfig(gridSize: MemoryGridSize.size3x2),
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
  );
}

abstract final class MemoryEndlessDemo {
  static final Topic topic = Topic(
    id: 'memory_endless',
    taskTypeCounts: {LearningTaskType.memory: 1},
    taskOrderMode: TaskOrderMode.deterministic,
    dataSource: FixedTaskDataSource([
      MemoryTaskData(
        prompt: _prompt,
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
    ),
    dashboard: const DashboardConfig(
      showProgress: false,
      showTimer: true,
      showRemainingAttempts: true,
    ),
  );
}
