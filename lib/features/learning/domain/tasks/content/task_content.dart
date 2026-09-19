abstract class TaskContent {
  const TaskContent();
}

class TextContent extends TaskContent {
  const TextContent(this.text);

  final String text;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TextContent && other.text == text;

  @override
  int get hashCode => text.hashCode;
}

class ImageContent extends TaskContent {
  const ImageContent(this.imagePath);

  final String imagePath;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageContent && other.imagePath == imagePath;

  @override
  int get hashCode => imagePath.hashCode;
}

/// Concrete, already-generated grid.
class GridContent extends TaskContent {
  const GridContent({
    required this.rows,
    required this.columns,
    required this.item,
  });

  final int rows;
  final int columns;
  final TaskContent item;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridContent &&
          other.rows == rows &&
          other.columns == columns &&
          other.item == item;

  @override
  int get hashCode => Object.hash(rows, columns, item);
}

class EmojiContent extends TaskContent {
  const EmojiContent(this.emoji);

  final String emoji;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is EmojiContent && other.emoji == emoji;

  @override
  int get hashCode => emoji.hashCode;
}
