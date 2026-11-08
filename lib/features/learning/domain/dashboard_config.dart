class DashboardConfig {
  const DashboardConfig({
    this.showProgress = true,
    this.showTimer = true,
    this.showRemainingAttempts = false,
    this.showStreak = false,
  });

  final bool showStreak;
  final bool showProgress;
  final bool showTimer;
  final bool showRemainingAttempts;
}
