class AutomaticTerminationConfig {
  const AutomaticTerminationConfig({
    this.countdown,
    this.failureLimit,
    this.pauseOnExitDialog = true,
  });

  final Duration? countdown;
  final int? failureLimit;

  /// Ставити гру на паузу, поки відкрито діалог виходу.
  final bool pauseOnExitDialog;
}
