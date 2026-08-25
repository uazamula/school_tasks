class PassingCriteria {
  const PassingCriteria({this.minimumAccuracy});

  /// Мінімальна частка правильних відповідей для зарахування теми.
  ///
  /// Наприклад, 0.8 означає 80%.
  final double? minimumAccuracy;
}
