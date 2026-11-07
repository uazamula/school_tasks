import 'dart:math';

import 'package:school_tasks/features/learning/domain/tasks/content/memory_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';

class MemoryBoardPicker {
  const MemoryBoardPicker({this.maxAttempts = 20});

  /// Жадібний добір може потрапити в глухий кут, тож повторюємо.
  final int maxAttempts;

  List<MemoryPair> pick({
    required List<MemoryPair> pool,
    required int count,
    required Random random,
    double Function(MemoryPair pair)? weightOf,
  }) {
    if (count > pool.length) {
      throw StateError('Need $count pairs, pool has ${pool.length}.');
    }

    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final board = _tryPick(pool, count, random, weightOf);
      if (board != null) return board;
    }

    throw StateError(
      'Cannot build a board of $count pairs without duplicate content '
      'from a pool of ${pool.length}.',
    );
  }

  List<MemoryPair>? _tryPick(
    List<MemoryPair> pool,
    int count,
    Random random,
    double Function(MemoryPair)? weightOf,
  ) {
    final candidates = List<MemoryPair>.of(pool);
    final board = <MemoryPair>[];

    while (board.length < count) {
      final eligible = [
        for (final c in candidates)
          if (!board.any((b) => conflicts(b, c))) c,
      ];

      if (eligible.isEmpty) return null;

      final picked = _pickWeighted(eligible, random, weightOf);
      board.add(picked);
      candidates.remove(picked);
    }

    return board;
  }

  static bool conflicts(MemoryPair a, MemoryPair b) =>
      sameVisual(a.hiddenContent, b.hiddenContent) ||
      sameVisual(a.faceFront, b.faceFront);

  static bool sameVisual(TaskContent a, TaskContent b) => switch ((a, b)) {
    (TextContent x, TextContent y) => x.text == y.text,
    (ImageContent x, ImageContent y) => x.imagePath == y.imagePath,
    (EmojiContent x, EmojiContent y) => x.emoji == y.emoji,
    _ => a == b,
  };

  MemoryPair _pickWeighted(
    List<MemoryPair> items,
    Random random,
    double Function(MemoryPair)? weightOf,
  ) {
    if (weightOf == null) return items[random.nextInt(items.length)];

    final total = items.fold<double>(0, (sum, p) => sum + weightOf(p));
    var threshold = random.nextDouble() * total;

    for (final item in items) {
      threshold -= weightOf(item);
      if (threshold < 0) return item;
    }

    return items.last;
  }
}
