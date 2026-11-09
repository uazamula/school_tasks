sealed class MemoryBoardMode {
  const MemoryBoardMode();
}

/// Одна дошка = одне завдання.
class FiniteMemoryMode extends MemoryBoardMode {
  const FiniteMemoryMode();
}

/// Нескінченна гра: нові дошки, доки не спрацює failureLimit/countdown.
class EndlessMemoryMode extends MemoryBoardMode {
  const EndlessMemoryMode({
    this.failedPairWeight = 1,
    this.targetStreak,
    this.continueAfterGoal = false,
  }) : assert(failedPairWeight >= 1),
       assert(targetStreak == null || targetStreak >= 1),
       assert(!continueAfterGoal || targetStreak != null);

  final double failedPairWeight;

  /// Мета: серія підряд. null — мети немає, рахується лише найкраща серія.
  final int? targetStreak;

  /// Після досягнення мети гра триває до завершення з інших причин.
  final bool continueAfterGoal;
}
