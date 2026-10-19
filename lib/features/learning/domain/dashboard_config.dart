class DashboardConfig {
  const DashboardConfig({
    this.showProgress = true,
    this.showTimer = true,
    this.showRemainingAttempts = false,
  });

  final bool showProgress;
  final bool showTimer;
  final bool showRemainingAttempts;
}
