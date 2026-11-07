enum MemoryGridSize {
  size2x2(2, 2),
  size3x2(3, 2),
  size4x2(4, 2),
  size5x2(5, 2),
  size3x4(3, 4),
  size3x6(3, 6),
  size4x4(4, 4),
  size4x5(4, 5),
  size4x6(4, 6);

  const MemoryGridSize(this.columns, this.rows);

  final int columns;
  final int rows;

  int get cardCount => columns * rows;

  /// Пар на дошці: A + B = дві картки.
  int get pairCount => cardCount ~/ 2;
}
