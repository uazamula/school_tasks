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

class EmojiContent extends TaskContent {
  const EmojiContent(this.emoji);

  final String emoji;
}
