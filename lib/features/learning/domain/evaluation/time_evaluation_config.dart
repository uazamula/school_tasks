class TimeEvaluationConfig {
  const TimeEvaluationConfig({
    required this.targetTime,
    required this.maximumTime,
  });

  /// Час, до якого завдання оцінюється як виконане оптимально.
  final Duration targetTime;

  /// Час, після якого оцінка за час стає 0.
  final Duration maximumTime;
}
