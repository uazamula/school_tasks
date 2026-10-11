import 'package:school_tasks/features/learning/domain/attempts/topic_completion_reason.dart';
import 'package:school_tasks/features/learning/domain/evaluation/accuracy_result.dart';
import 'package:school_tasks/features/learning/domain/evaluation/criterion_evaluation_result.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_result.dart';

class TopicAttemptSnapshot {
  const TopicAttemptSnapshot({
    required this.completedAt,
    required this.duration,
    required this.completedTasks,
    required this.totalTasks,
    required this.accuracy,
    required this.score,
    required this.isPassed,
    required this.completionReason,
    this.evaluation,
  });

  final DateTime completedAt;
  final Duration duration;
  final int completedTasks;
  final int totalTasks;
  final AccuracyResult accuracy;

  /// Фінальна оцінка, яку зберігаємо для відображення результату.
  ///
  /// Якщо спробу не зараховано, значення дорівнює 0.
  final double score;

  final bool isPassed;
  final TopicCompletionReason completionReason;
  final EvaluationResult? evaluation;

  Map<String, dynamic> toJson() {
    return {
      'completedAt': completedAt.toIso8601String(),
      'durationMs': duration.inMilliseconds,
      'completedTasks': completedTasks,
      'totalTasks': totalTasks,
      'accuracy': {'correct': accuracy.correct, 'total': accuracy.total},
      'score': score,
      'isPassed': isPassed,
      'completionReason': completionReason.name,
      'evaluation': _evaluationToJson(evaluation),
    };
  }

  factory TopicAttemptSnapshot.fromJson(Map<String, dynamic> json) {
    final accuracyJson = Map<String, dynamic>.from(json['accuracy'] as Map);

    return TopicAttemptSnapshot(
      completedAt: DateTime.parse(json['completedAt'] as String),
      duration: Duration(milliseconds: (json['durationMs'] as num).toInt()),
      completedTasks: (json['completedTasks'] as num).toInt(),
      totalTasks: (json['totalTasks'] as num).toInt(),
      accuracy: AccuracyResult(
        correct: (accuracyJson['correct'] as num).toInt(),
        total: (accuracyJson['total'] as num).toInt(),
      ),
      score: (json['score'] as num).toDouble(),
      isPassed: json['isPassed'] as bool,
      completionReason: TopicCompletionReason.values.byName(
        json['completionReason'] as String,
      ),
      evaluation: _evaluationFromJson(json['evaluation']),
    );
  }

  static Map<String, dynamic>? _evaluationToJson(EvaluationResult? evaluation) {
    if (evaluation == null) return null;

    return {
      'finalScore': evaluation.finalScore,
      'isPassed': evaluation.isPassed,
      'criterionResults': {
        for (final entry in evaluation.criterionResults.entries)
          entry.key.name: {
            'measurement': entry.value.measurement,
            'score': entry.value.score,
            'weight': entry.value.weight,
            'weightedScore': entry.value.weightedScore,
          },
      },
    };
  }

  static EvaluationResult? _evaluationFromJson(dynamic value) {
    if (value == null) return null;

    final json = Map<String, dynamic>.from(value as Map);
    final rawResults = Map<String, dynamic>.from(
      json['criterionResults'] as Map,
    );

    final criterionResults =
        <EvaluationCriterionType, CriterionEvaluationResult>{};

    for (final entry in rawResults.entries) {
      final criterion = EvaluationCriterionType.values.byName(entry.key);
      final resultJson = Map<String, dynamic>.from(entry.value as Map);

      criterionResults[criterion] = CriterionEvaluationResult(
        criterion: criterion,
        measurement: (resultJson['measurement'] as num).toDouble(),
        score: (resultJson['score'] as num).toDouble(),
        weight: (resultJson['weight'] as num).toDouble(),
        weightedScore: (resultJson['weightedScore'] as num).toDouble(),
      );
    }

    return EvaluationResult(
      criterionResults: criterionResults,
      finalScore: (json['finalScore'] as num).toDouble(),
      isPassed: json['isPassed'] as bool,
    );
  }
}
