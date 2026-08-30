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
