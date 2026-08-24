class CriterionResult {
  const CriterionResult({required this.measurement, required this.score});

  /// Кількісний вимір критерію.
  final double measurement;

  /// Нормалізована оцінка критерію від 0 до 1.
  final double score;
}
