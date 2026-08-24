class EvaluationConfig {
  const EvaluationConfig({required this.accuracyWeight});

  /// Вага критерію точності.
  ///
  /// Значення від 0 до 1.
  /// Наприклад: 0.7 = 70%.
  final double accuracyWeight;
}
