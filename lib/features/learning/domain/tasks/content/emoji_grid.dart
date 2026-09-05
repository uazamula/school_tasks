import 'package:flutter/cupertino.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';

class EmojiGrid {
  const EmojiGrid(this.rows);

  final List<String> rows;

  List<List<EmojiContent>> get content => [
    for (final row in rows)
      [for (final emoji in row.characters) EmojiContent(emoji)],
  ];
}
