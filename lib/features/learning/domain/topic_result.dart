class TopicResult {
  const TopicResult({
    required this.currentScore,
    required this.currentIsPassed,
    required this.currentAt,
    required this.currentDuration,
    required this.bestScore,
    required this.bestAt,
    required this.bestDuration,
  });

  /// Фінальна оцінка останнього зарахованого проходження, 0..1.
  final double currentScore;

  /// Чи була тема зарахована під час останнього проходження.
  final bool currentIsPassed;

  /// Момент останнього проходження.
  final DateTime currentAt;

  /// Тривалість останнього проходження.
  final Duration currentDuration;

  /// Найкраща фінальна оцінка, 0..1.
  final double bestScore;

  /// Момент встановлення найкращого результату.
  final DateTime? bestAt;

  /// Тривалість найкращого проходження.
  final Duration? bestDuration;
}
