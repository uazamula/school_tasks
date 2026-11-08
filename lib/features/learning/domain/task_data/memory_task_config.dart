import 'package:school_tasks/features/learning/domain/task_data/memory_card_style_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/memory_grid_size.dart';
import 'package:school_tasks/features/learning/domain/task_data/memory_zone_order.dart';

class MemoryTaskConfig {
  const MemoryTaskConfig({
    this.gridSize = MemoryGridSize.size3x2,
    this.peekDuration,
    this.timeoutCountsAsError = true,
    this.mismatchDelay = const Duration(milliseconds: 800),
    this.flipDuration = const Duration(milliseconds: 400),
    this.separatedZones = true,
    this.adaptiveOrientation = true,
    this.cardStyle = const MemoryCardStyleConfig(),
    this.playAudioOnReveal = true,
    this.replayAudioOnMatch = false,
    this.cardAspectRatio = 1.0,
    this.maxCardSize = 160,
    this.zoneOrder = MemoryZoneOrder.aFirst,
  }) : assert(cardAspectRatio > 0),
       assert(maxCardSize > 0);

  /// Ширина / висота картки. Для слів можна 1.4 і більше.
  final double cardAspectRatio;

  /// Максимальна ширина картки (px), щоб на вебі вони не були величезними.
  final double maxCardSize;

  /// Яка зона A/B перша (зверху або ліворуч). Лише для separatedZones.
  final MemoryZoneOrder zoneOrder;

  final MemoryGridSize gridSize;

  /// Скільки B лишається відкритою в очікуванні вибору A.
  /// null — без обмеження. Після спливу B перевертається назад.
  final Duration? peekDuration;

  /// Чи рахується спливання peekDuration помилкою.
  final bool timeoutCountsAsError;

  /// Пауза перед поверненням неправильної пари.
  final Duration mismatchDelay;

  final Duration flipDuration;

  /// A і B в окремих зонах (true) або перемішані в одній сітці.
  final bool separatedZones;

  /// Міняти місцями колонки/рядки залежно від орієнтації екрана.
  final bool adaptiveOrientation;

  final MemoryCardStyleConfig cardStyle;

  final bool playAudioOnReveal;
  final bool replayAudioOnMatch;
}
