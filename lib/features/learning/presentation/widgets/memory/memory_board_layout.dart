import 'dart:math';
import 'dart:ui';

import 'package:school_tasks/features/learning/domain/task_data/memory_grid_size.dart';
import 'package:school_tasks/features/learning/domain/task_data/memory_zone_order.dart';

class MemoryBoardLayout {
  const MemoryBoardLayout({
    required this.cardSize,
    required this.boardSize,
    required this.zoneA,
    required this.zoneB,
    required this.mixed,
  });

  final Size cardSize;
  final Size boardSize;

  /// Позиції в зонах (separatedZones). Порожні в змішаному режимі.
  final List<Offset> zoneA;
  final List<Offset> zoneB;

  /// Позиції в одній сітці (змішаний режим).
  final List<Offset> mixed;

  /// Позицію визначає (зона, порядковий номер), а не індекс слота,
  /// тож зміна орієнтації екрана не перемішує зони.
  Offset offsetOf({
    required bool separated,
    required bool isB,
    required int ordinal,
  }) {
    if (!separated) return mixed[ordinal];
    return (isB ? zoneB : zoneA)[ordinal];
  }

  static MemoryBoardLayout compute({
    required MemoryGridSize gridSize,
    required bool separatedZones,
    required bool adaptiveOrientation,
    required double aspect,
    required double maxCardSize,
    required MemoryZoneOrder zoneOrder,
    required Size available,
    double spacing = 8,
    double zoneGap = 24,
  }) {
    final options = <(int, int)>[(gridSize.columns, gridSize.rows)];

    if (adaptiveOrientation && gridSize.columns != gridSize.rows) {
      options.add((gridSize.rows, gridSize.columns));
    }

    MemoryBoardLayout? best;

    for (final (cols, rows) in options) {
      final candidate = _arrange(
        cols: cols,
        rows: rows,
        separated: separatedZones,
        aspect: aspect,
        maxCardSize: maxCardSize,
        zoneOrder: zoneOrder,
        available: available,
        spacing: spacing,
        zoneGap: zoneGap,
      );

      // Строго більша картка, щоб за рівності лишити задану орієнтацію.
      if (best == null ||
          candidate.cardSize.width > best.cardSize.width + 0.5) {
        best = candidate;
      }
    }

    return best!;
  }

  static MemoryBoardLayout _arrange({
    required int cols,
    required int rows,
    required bool separated,
    required double aspect,
    required double maxCardSize,
    required MemoryZoneOrder zoneOrder,
    required Size available,
    required double spacing,
    required double zoneGap,
  }) {
    // Зони йдуть стовпчиком, якщо рядків парна кількість, інакше поруч.
    // Усі розміри з MemoryGridSize мають хоча б один парний вимір.
    final stacked = separated && rows.isEven;
    final sideBySide = separated && !stacked && cols.isEven;
    final split = stacked || sideBySide;

    final zoneCols = sideBySide ? cols ~/ 2 : cols;
    final zoneRows = stacked ? rows ~/ 2 : rows;

    final hGap = sideBySide
        ? 2 * (zoneCols - 1) * spacing + zoneGap
        : (cols - 1) * spacing;
    final vGap = stacked
        ? 2 * (zoneRows - 1) * spacing + zoneGap
        : (rows - 1) * spacing;

    final byWidth = (available.width - hGap) / cols;
    final byHeight = (available.height - vGap) / rows * aspect;

    final width = max(0.0, min(min(byWidth, byHeight), maxCardSize));
    final height = width / aspect;
    final step = Offset(width + spacing, height + spacing);

    List<Offset> grid(Offset origin, int c, int r) => [
      for (var y = 0; y < r; y++)
        for (var x = 0; x < c; x++) origin + Offset(x * step.dx, y * step.dy),
    ];

    final boardSize = Size(cols * width + hGap, rows * height + vGap);

    if (!split) {
      return MemoryBoardLayout(
        cardSize: Size(width, height),
        boardSize: boardSize,
        zoneA: const [],
        zoneB: const [],
        mixed: grid(Offset.zero, cols, rows),
      );
    }

    final secondOrigin = stacked
        ? Offset(0, zoneRows * height + (zoneRows - 1) * spacing + zoneGap)
        : Offset(zoneCols * width + (zoneCols - 1) * spacing + zoneGap, 0);

    final first = grid(Offset.zero, zoneCols, zoneRows);
    final second = grid(secondOrigin, zoneCols, zoneRows);
    final aFirst = zoneOrder == MemoryZoneOrder.aFirst;

    return MemoryBoardLayout(
      cardSize: Size(width, height),
      boardSize: boardSize,
      zoneA: aFirst ? first : second,
      zoneB: aFirst ? second : first,
      mixed: const [],
    );
  }
}
