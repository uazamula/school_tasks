class PassingCriteria {
  const PassingCriteria({this.minimumAccuracy, this.maximumTime});

  /// Мінімальна частка правильних відповідей для зарахування теми.
  ///
  /// Наприклад, 0.8 означає 80%.
  final double? minimumAccuracy;

  /// Максимальний час проходження для зарахування теми.
  ///
  /// Якщо проходження триває довше, тема не зараховується.
  final Duration? maximumTime;
}
