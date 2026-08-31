import 'dart:math';

abstract class TaskContent {
  const TaskContent();
}

class TextContent extends TaskContent {
  const TextContent(this.text);

  final String text;
}

class ImageContent extends TaskContent {
  const ImageContent(this.imagePath);

  final String imagePath;
}

/// Опис сітки з випадковою кількістю рядків і стовпців.
class GridContent extends TaskContent {
  const GridContent({
    required this.rows,
    required this.columns,
    required this.item,
  });

  final RandomFrom<int> rows;
  final RandomFrom<int> columns;
  final TaskContent item;
}

/// Конкретна, вже згенерована сітка.
class GeneratedGridContent extends TaskContent {
  const GeneratedGridContent({
    required this.rows,
    required this.columns,
    required this.item,
  });

  final int rows;
  final int columns;
  final TaskContent item;
}

class RandomFrom<T> {
  const RandomFrom(this.values);

  final List<T> values;

  T generate(Random random) {
    if (values.isEmpty) {
      throw StateError('Cannot select a random value from an empty list.');
    }

    return values[random.nextInt(values.length)];
  }
}
