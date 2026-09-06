class AccuracyResult {
  const AccuracyResult({required this.correct, required this.total});

  final int correct;
  final int total;

  double get value {
    if (total == 0) {
      return 0;
    }

    return correct / total;
  }
}
