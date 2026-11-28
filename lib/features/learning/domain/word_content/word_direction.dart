/// Напрямок, у якому слово йде по сітці (крок за рядком і стовпцем).
enum WordDirection {
  right(0, 1),
  down(1, 0),
  left(0, -1),
  up(-1, 0),
  downRight(1, 1),
  downLeft(1, -1),
  upRight(-1, 1),
  upLeft(-1, -1);

  const WordDirection(this.rowStep, this.columnStep);

  final int rowStep;
  final int columnStep;

  /// Для початківців: зліва направо та зверху вниз.
  static const Set<WordDirection> easy = {
    WordDirection.right,
    WordDirection.down,
  };

  /// Додається діагональ униз-вправо.
  static const Set<WordDirection> withDiagonal = {
    WordDirection.right,
    WordDirection.down,
    WordDirection.downRight,
  };

  /// Усі вісім напрямків.
  static const Set<WordDirection> all = {...WordDirection.values};
}
