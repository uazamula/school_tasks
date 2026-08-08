import 'dart:io';

/// Параметри друку дерева каталогів.
///
/// Використовується TreePrinter і нічого не знає про CLI.
final class TreeOptions {
  const TreeOptions({
    required this.root,
    this.showDirectories = true,
    this.showFiles = true,
    this.maxDepth,
  });

  /// Коренева директорія.
  final Directory root;

  /// Показувати каталоги.
  final bool showDirectories;

  /// Показувати файли.
  final bool showFiles;

  /// Максимальна глибина.
  ///
  /// null = без обмеження.
  final int? maxDepth;
}