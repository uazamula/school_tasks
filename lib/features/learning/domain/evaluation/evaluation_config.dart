import 'evaluation_criterion_type.dart';

class EvaluationConfig {
  const EvaluationConfig({required this.weights});

  final Map<EvaluationCriterionType, double> weights;

  double normalizedWeight(EvaluationCriterionType type) {
    final totalWeight = weights.values.fold(0.0, (sum, weight) => sum + weight);

    if (totalWeight <= 0) {
      return 0;
    }

    return (weights[type] ?? 0) / totalWeight;
  }
}
