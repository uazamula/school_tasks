class AutomaticTerminationConfig {
  const AutomaticTerminationConfig({this.countdown, this.failureLimit});

  final Duration? countdown;
  final int? failureLimit;
}
