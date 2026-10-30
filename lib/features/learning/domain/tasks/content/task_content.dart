import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';

abstract class TaskContent {
  const TaskContent();

  /// Аудіо, прикріплене до контенту. Для типів без аудіо — null.
  AudioContent? get audio => null;
}

class TextContent extends TaskContent {
  const TextContent(this.text, {this.audio});

  final String text;
  @override
  final AudioContent? audio;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextContent && other.text == text && other.audio == audio;

  @override
  int get hashCode => Object.hash(text, audio);
}

class ImageContent extends TaskContent {
  const ImageContent(this.imagePath, {this.audio});

  final String imagePath;
  @override
  final AudioContent? audio;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageContent &&
          other.imagePath == imagePath &&
          other.audio == audio;

  @override
  int get hashCode => Object.hash(imagePath, audio);
}

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
  const EmojiContent(this.emoji, {this.audio});

  final String emoji;
  @override
  final AudioContent? audio;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmojiContent && other.emoji == emoji && other.audio == audio;

  @override
  int get hashCode => Object.hash(emoji, audio);
}
