import 'dart:math';

import 'package:school_tasks/features/learning/domain/tasks/content/memory_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/memory_board_source.dart';

class WeightedMemoryBoardSource implements MemoryBoardSource {
  WeightedMemoryBoardSource({
    required List<MemoryPair> pool,
    required this.pairsPerBoard,
    this.failedPairWeight = 1,
    Random? random,
  }) : _pool = List.unmodifiable(pool),
       _random = random ?? Random() {
    assert(pool.every((pair) => pair.id != null));
    assert(pool.length >= pairsPerBoard);
  }

  @override
  final int pairsPerBoard;

  final double failedPairWeight;

  final List<MemoryPair> _pool;
  final Random _random;
  final Map<String, double> _weights = {};

  @override
  List<MemoryPair> nextBoard() {
    final candidates = List<MemoryPair>.of(_pool);
    final board = <MemoryPair>[];

    while (board.length < pairsPerBoard) {
      final eligible = candidates
          .where((c) => !board.any((b) => _conflicts(b, c)))
          .toList();

      if (eligible.isEmpty) {
        throw StateError(
          'Cannot build a board of $pairsPerBoard pairs without '
          'duplicate content. Pool is too small or too repetitive.',
        );
      }

      final picked = _pickWeighted(eligible);
      board.add(picked);
      candidates.remove(picked);
    }

    return board;
  }

  @override
  void reportPairResult(String pairId, {required bool failed}) {
    if (failed) {
      _weights[pairId] = failedPairWeight;
    } else {
      _weights.remove(pairId);
    }
  }

  bool _conflicts(MemoryPair a, MemoryPair b) =>
      a.hiddenContent == b.hiddenContent || a.faceFront == b.faceFront;

  MemoryPair _pickWeighted(List<MemoryPair> items) {
    double weightOf(MemoryPair p) => _weights[p.id] ?? 1.0;

    final total = items.fold<double>(0, (sum, p) => sum + weightOf(p));
    var threshold = _random.nextDouble() * total;

    for (final item in items) {
      threshold -= weightOf(item);
      if (threshold < 0) return item;
    }

    return items.last;
  }
}
