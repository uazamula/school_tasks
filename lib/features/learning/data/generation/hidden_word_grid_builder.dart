import 'dart:math';

import 'package:school_tasks/features/learning/domain/grid_position.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_direction.dart';

/// Сітка із захованим словом.
class HiddenWordGrid {
  const HiddenWordGrid({required this.cells, required this.positions});

  /// Літери всіх клітинок (рядки × стовпці).
  final List<List<String>> cells;

  /// Позиції літер слова за порядком (нумерація з 1, як у GridPosition).
  final List<GridPosition> positions;
}

/// Ховає слово в сітці та заповнює решту літерами без випадкових дублів слова.
class HiddenWordGridBuilder {
  HiddenWordGridBuilder({
    required this.rows,
    required this.columns,
    required List<String> alphabet,
    Set<WordDirection> directions = WordDirection.easy,
    Random? random,
  }) : alphabet = List.unmodifiable(alphabet),
       directions = Set.unmodifiable(directions),
       _random = random ?? Random() {
    if (rows < 1 || columns < 1) {
      throw ArgumentError('rows and columns must be at least 1.');
    }
    if (this.alphabet.length < 2) {
      throw ArgumentError('alphabet must contain at least 2 letters.');
    }
    if (this.directions.isEmpty) {
      throw ArgumentError('directions must not be empty.');
    }
  }

  final int rows;
  final int columns;
  final List<String> alphabet;
  final Set<WordDirection> directions;
  final Random _random;

  // Скільки разів намагаємось прибрати випадкові входження слова.
  static const int _maxRepairs = 200;

  /// Повертає null, якщо слово не вміщається в сітку в жодному
  /// з дозволених напрямків.
  HiddenWordGrid? build(List<String> word) {
    if (word.isEmpty) {
      throw ArgumentError('word must not be empty.');
    }

    final placed = _place(word);
    if (placed == null) return null;

    final cells = List.generate(
      rows,
      (_) => List<String?>.filled(columns, null),
    );

    for (var i = 0; i < word.length; i++) {
      cells[placed[i] ~/ columns][placed[i] % columns] = word[i];
    }

    final placedSet = placed.toSet();

    for (var row = 0; row < rows; row++) {
      for (var column = 0; column < columns; column++) {
        cells[row][column] ??= _randomLetter();
      }
    }

    _removeExtraOccurrences(cells, word, placedSet);

    return HiddenWordGrid(
      cells: [
        for (final row in cells) [for (final letter in row) letter!],
      ],
      positions: [
        for (final index in placed)
          GridPosition(row: index ~/ columns + 1, column: index % columns + 1),
      ],
    );
  }

  /// Індекси клітинок слова (рядок * columns + стовпець) або null.
  List<int>? _place(List<String> word) {
    final candidates = <(int, int, WordDirection)>[];

    for (final direction in directions) {
      for (var row = 0; row < rows; row++) {
        for (var column = 0; column < columns; column++) {
          if (_fits(row, column, direction, word.length)) {
            candidates.add((row, column, direction));
          }
        }
      }
    }

    if (candidates.isEmpty) return null;

    final (row, column, direction) =
        candidates[_random.nextInt(candidates.length)];

    return _line(row, column, direction, word.length);
  }

  bool _fits(int row, int column, WordDirection direction, int length) {
    final lastRow = row + direction.rowStep * (length - 1);
    final lastColumn = column + direction.columnStep * (length - 1);

    return lastRow >= 0 &&
        lastRow < rows &&
        lastColumn >= 0 &&
        lastColumn < columns;
  }

  List<int> _line(int row, int column, WordDirection direction, int length) {
    return [
      for (var i = 0; i < length; i++)
        (row + direction.rowStep * i) * columns +
            (column + direction.columnStep * i),
    ];
  }

  String _randomLetter() => alphabet[_random.nextInt(alphabet.length)];

  /// Замінює літери-заповнювачі, доки слово не залишиться в сітці лише раз.
  void _removeExtraOccurrences(
    List<List<String?>> cells,
    List<String> word,
    Set<int> placed,
  ) {
    for (var attempt = 0; attempt < _maxRepairs; attempt++) {
      final extra = _findOtherOccurrence(cells, word, placed);
      if (extra == null) return;

      // Входження завжди містить хоча б одну клітинку-заповнювач.
      final fillers = extra.where((i) => !placed.contains(i)).toList();
      final index = fillers[_random.nextInt(fillers.length)];
      final current = cells[index ~/ columns][index % columns];

      String replacement;
      do {
        replacement = _randomLetter();
      } while (replacement == current);

      cells[index ~/ columns][index % columns] = replacement;
    }

    throw StateError(
      'Could not remove extra occurrences of the word from the grid.',
    );
  }

  /// Перше входження слова (у будь-якому з 8 напрямків), відмінне
  /// від розміщеного. Порівняння за наборами клітинок, тому слово-паліндром,
  /// прочитане навпаки, дублем не вважається.
  List<int>? _findOtherOccurrence(
    List<List<String?>> cells,
    List<String> word,
    Set<int> placed,
  ) {
    for (final direction in WordDirection.values) {
      for (var row = 0; row < rows; row++) {
        for (var column = 0; column < columns; column++) {
          if (!_fits(row, column, direction, word.length)) continue;

          final line = _line(row, column, direction, word.length);

          var matches = true;
          for (var i = 0; i < word.length; i++) {
            if (cells[line[i] ~/ columns][line[i] % columns] != word[i]) {
              matches = false;
              break;
            }
          }

          if (!matches) continue;

          final isPlaced =
              line.length == placed.length && line.every(placed.contains);

          if (!isPlaced) return line;
        }
      }
    }

    return null;
  }
}
