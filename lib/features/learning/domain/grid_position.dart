class GridPosition {
  const GridPosition({required this.row, required this.column});

  final int row;
  final int column;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridPosition && other.row == row && other.column == column;

  @override
  int get hashCode => Object.hash(row, column);
}
