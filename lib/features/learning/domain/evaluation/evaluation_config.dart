import 'evaluation_criterion_type.dart';
import 'time_evaluation_config.dart';

class EvaluationConfig {
  const EvaluationConfig({required this.weights, this.time});

  final Map<EvaluationCriterionType, double> weights;

  /// Налаштування критерію часу.
  ///
  /// null означає, що додаткових налаштувань часу для теми немає.
  final TimeEvaluationConfig? time;

  double normalizedWeight(EvaluationCriterionType type) {
    final totalWeight = weights.values.fold(0.0, (sum, weight) => sum + weight);

    if (totalWeight <= 0) {
      return 0;
    }

    return (weights[type] ?? 0) / totalWeight;
  }
}
