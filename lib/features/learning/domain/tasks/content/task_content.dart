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

/// Конкретна, вже згенерована сітка.
class GridContent extends TaskContent {
  const GridContent({
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
