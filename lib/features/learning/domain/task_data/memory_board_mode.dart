sealed class MemoryBoardMode {
  const MemoryBoardMode();
}

/// Одна дошка = одне завдання.
class FiniteMemoryMode extends MemoryBoardMode {
  const FiniteMemoryMode();
}

/// Нескінченна гра: нові дошки, доки не спрацює failureLimit/countdown.
class EndlessMemoryMode extends MemoryBoardMode {
  const EndlessMemoryMode({this.failedPairWeight = 1})
    : assert(failedPairWeight >= 1);

  /// Множник імовірності для пар, у яких була помилка (1 — без підсилення).
  final double failedPairWeight;
}
