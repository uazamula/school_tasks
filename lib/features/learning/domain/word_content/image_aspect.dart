import 'double_range.dart';

/// Готові діапазони співвідношення сторін зображення (ширина / висота).
///
/// Межі орієнтовні; їх варто уточнити за звітом
/// `dart run tool/project_tools.dart images --report`.
/// На межі (0.9 і 1.1) зображення підходить одразу двом діапазонам.
abstract final class ImageAspect {
  /// Майже квадратне.
  static const DoubleRange square = DoubleRange(min: 0.9, max: 1.1);

  /// Горизонтальне (ширше, ніж квадрат).
  static const DoubleRange landscape = DoubleRange.atLeast(1.1);

  /// Вертикальне (вужче, ніж квадрат).
  static const DoubleRange portrait = DoubleRange.atMost(0.9);
}
