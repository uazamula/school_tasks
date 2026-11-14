import 'double_range.dart';

/// Готові діапазони співвідношення сторін зображення (ширина / висота).
///
/// Межі орієнтовні; їх варто уточнити за звітом
/// `dart run tool/project_tools.dart images --report`.
/// На межі (0.9 і 1.1) зображення підходить одразу двом діапазонам.
abstract final class ImageAspect {
  /// Допустиме відхилення: довша сторона більша за коротшу не більше ніж на 20%.
  static const double _squareTolerance = 0.2;

  static const double _maxRatio = 1 + _squareTolerance; // 1.2

  /// Майже квадратне: від 1/1.2 до 1.2.
  static const DoubleRange square = DoubleRange(
    min: 1 / _maxRatio,
    max: _maxRatio,
  );

  /// Горизонтальне (ширше, ніж квадрат).
  static const DoubleRange landscape = DoubleRange.atLeast(_maxRatio);

  /// Вертикальне (вужче, ніж квадрат).
  static const DoubleRange portrait = DoubleRange.atMost(1 / _maxRatio);
}
