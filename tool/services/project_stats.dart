final class ProjectStats {
  const ProjectStats({
    required this.root,
    required this.directories,
    required this.files,
    required this.dartFiles,
    required this.linesOfCode,
  });

  /// Проаналізована директорія.
  final String root;

  /// Кількість директорій.
  final int directories;

  /// Загальна кількість файлів.
  final int files;

  /// Кількість *.dart файлів.
  final int dartFiles;

  /// Загальна кількість рядків у *.dart файлах.
  final int linesOfCode;
}