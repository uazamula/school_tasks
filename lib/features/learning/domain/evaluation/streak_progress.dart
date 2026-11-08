import 'dart:math';

class StreakProgress {
  const StreakProgress({this.current = 0, this.best = 0, this.pairs = 0});

  final int current;
  final int best;
  final int pairs;

  StreakProgress registerCorrect() {
    final next = current + 1;
    return StreakProgress(
      current: next,
      best: max(best, next),
      pairs: pairs + 1,
    );
  }

  StreakProgress registerError() =>
      StreakProgress(current: 0, best: best, pairs: pairs);
}
