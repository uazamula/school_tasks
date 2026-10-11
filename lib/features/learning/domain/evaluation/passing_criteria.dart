class PassingCriteria {
  const PassingCriteria({
    this.minimumAccuracy,
    this.maximumTime,
    this.maximumFailures,
  });

  /// Мінімальна частка правильних відповідей для зарахування теми.
  ///
  /// Наприклад, 0.8 означає 80%.
  final double? minimumAccuracy;

  /// Максимальний час проходження для зарахування теми.
  ///
  /// Якщо проходження триває довше, тема не зараховується.
  final Duration? maximumTime;

  /// Максимальна кількість помилкових спроб, дозволених для зарахування.
  ///
  /// Якщо кількість помилок досягає цього значення,
  /// тема не зараховується.
  final int? maximumFailures;
}
