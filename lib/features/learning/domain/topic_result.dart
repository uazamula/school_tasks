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

  Map<String, dynamic> toJson() {
    return {
      'currentScore': currentScore,
      'currentIsPassed': currentIsPassed,
      'currentAt': currentAt.toIso8601String(),
      'currentDurationMs': currentDuration.inMilliseconds,
      'bestScore': bestScore,
      'bestAt': bestAt?.toIso8601String(),
      'bestDurationMs': bestDuration?.inMilliseconds,
    };
  }

  factory TopicResult.fromJson(Map<String, dynamic> json) {
    return TopicResult(
      currentScore: (json['currentScore'] as num).toDouble(),
      currentIsPassed: json['currentIsPassed'] as bool,
      currentAt: DateTime.parse(json['currentAt'] as String),
      currentDuration: Duration(milliseconds: json['currentDurationMs'] as int),
      bestScore: (json['bestScore'] as num).toDouble(),
      bestAt: json['bestAt'] == null
          ? null
          : DateTime.parse(json['bestAt'] as String),
      bestDuration: json['bestDurationMs'] == null
          ? null
          : Duration(milliseconds: json['bestDurationMs'] as int),
    );
  }
}
