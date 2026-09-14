import 'package:school_tasks/features/learning/domain/evaluation/evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/evaluation/passing_criteria.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/task_data_source.dart';
import 'package:school_tasks/features/learning/domain/topic_layout.dart';
import 'package:school_tasks/features/learning/domain/topic_progression_mode.dart';

class Topic {
  Topic({
    required this.id,
    required this.taskTypeCounts,
    required this.dataSource,
    required this.help,
    required this.evaluation,
    this.passingCriteria,
    this.layout = const TopicLayout.standard(),
    this.progressionMode = TopicProgressionMode.automatic,
    this.feedbackDuration = const Duration(milliseconds: 500),
  });

  final String id;
  final Map<LearningTaskType, int> taskTypeCounts;
  final TaskDataSource dataSource;
  final String help;
  final EvaluationConfig evaluation;
  final PassingCriteria? passingCriteria;
  final TopicLayout layout;
  final TopicProgressionMode progressionMode;
  final Duration feedbackDuration;

  int get totalTasks {
    return taskTypeCounts.values.fold(0, (sum, count) => sum + count);
  }
}
