import 'package:school_tasks/features/learning/domain/tasks/content/memory_pair.dart';

abstract class MemoryBoardSource {
  int get pairsPerBoard;

  /// Наступна дошка. Порядок розкладання карток визначає віджет.
  List<MemoryPair> nextBoard();

  /// Результат пари: failed = true, якщо була помилка.
  void reportPairResult(String pairId, {required bool failed});
}
