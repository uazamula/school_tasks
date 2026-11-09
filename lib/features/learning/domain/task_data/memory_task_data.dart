import 'package:school_tasks/features/learning/domain/task_data/memory_board_mode.dart';
import 'package:school_tasks/features/learning/domain/task_data/memory_task_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/memory_pair.dart';

class MemoryTaskData extends TaskData {
  const MemoryTaskData({
    required super.prompt,
    required this.pairPool,
    this.mode = const FiniteMemoryMode(),
    this.config = const MemoryTaskConfig(),
  }) : assert(pairPool.length >= 1);

  final List<MemoryPair> pairPool;
  final MemoryBoardMode mode;
  final MemoryTaskConfig config;

  /// Пул, де кожна пара має id (за індексом, якщо автор його не задав).
  List<MemoryPair> get normalizedPool => [
    for (var i = 0; i < pairPool.length; i++)
      pairPool[i].id == null ? pairPool[i].withId('pair_$i') : pairPool[i],
  ];
}
