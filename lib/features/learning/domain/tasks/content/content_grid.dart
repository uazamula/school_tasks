import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/grid_position.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';

/// Прямокутна сітка контенту для завдань на вибір позиції.
/// Не плутати з GridContent: той малює один елемент, повторений у сітці.
class ContentGrid {
  ContentGrid(List<List<TaskContent>> cells)
    : assert(
        cells.isNotEmpty &&
            cells.first.isNotEmpty &&
            cells.every((row) => row.length == cells.first.length),
        'Сітка має бути непорожньою і прямокутною',
      ),
      cells = List.unmodifiable([
        for (final row in cells) List<TaskContent>.unmodifiable(row),
      ]);

  /// Кожен символ рядка — емодзі.
  factory ContentGrid.emoji(List<String> rows) => ContentGrid([
    for (final row in rows)
      [for (final symbol in row.characters) EmojiContent(symbol)],
  ]);

  /// Кожен символ рядка — літера (текст).
  factory ContentGrid.letters(List<String> rows) => ContentGrid([
    for (final row in rows)
      [for (final symbol in row.characters) TextContent(symbol)],
  ]);

  final List<List<TaskContent>> cells;

  int get rows => cells.length;

  int get columns => cells.first.length;

  /// Контент за позицією (нумерація з 1, як у GridPosition).
  TaskContent at(GridPosition position) =>
      cells[position.row - 1][position.column - 1];
}
