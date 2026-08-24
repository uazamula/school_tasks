import 'evaluation_criterion_type.dart';

class CriterionEvaluationResult {
  const CriterionEvaluationResult({
    required this.criterion,
    required this.measurement,
    required this.score,
    required this.weight,
    required this.weightedScore,
  });

  final EvaluationCriterionType criterion;

  /// Фактичний вимір критерію.
  ///
  /// Для accuracy — частка правильних відповідей.
  /// Для time — кількість секунд.
  final double measurement;

  /// Нормалізована оцінка критерію від 0 до 1.
  final double score;

  /// Ефективна нормалізована вага критерію.
  final double weight;

  /// Внесок критерію у фінальну оцінку.
  final double weightedScore;
}
