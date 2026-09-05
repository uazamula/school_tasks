import 'package:flutter/cupertino.dart';

import 'task_content.dart';

class EmojiGrid {
  const EmojiGrid(this.rows);

  final List<String> rows;

  List<List<TaskContent>> get content => [
    for (final row in rows)
      [for (final emoji in row.characters) EmojiContent(emoji)],
  ];
}
