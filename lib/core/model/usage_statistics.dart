class UsageStatistics {
  const UsageStatistics({required this.totalUsage, required this.todayUsage});

  final Duration totalUsage;
  final Duration todayUsage;

  UsageStatistics copyWith({Duration? totalUsage, Duration? todayUsage}) {
    return UsageStatistics(
      totalUsage: totalUsage ?? this.totalUsage,
      todayUsage: todayUsage ?? this.todayUsage,
    );
  }
}
