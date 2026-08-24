class TopicAttemptResult {
  const TopicAttemptResult({
    required this.totalTasks,
    required this.completedTasks,
    required this.correctTasks,
  });

  final int totalTasks;
  final int completedTasks;
  final int correctTasks;

  bool get isFinished => completedTasks == totalTasks;

  // double get score {
  //   if (totalTasks == 0) {
  //     return 0;
  //   }
  //
  //   return correctTasks / totalTasks;
  // }
}
