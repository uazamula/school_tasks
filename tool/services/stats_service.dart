import 'dart:io';

import 'project_stats.dart';

final class StatsService {
  static const _ignored = {'.dart_tool', '.git', '.idea', '.DS_Store', 'build'};

  ProjectStats collect(Directory root) {
    var directories = 0;
    var files = 0;
    var dartFiles = 0;
    var linesOfCode = 0;

    void walk(Directory directory) {
      final entities = directory.listSync();

      for (final entity in entities) {
        final name = _name(entity);

        if (_ignored.contains(name) || name.startsWith('.')) {
          continue;
        }

        if (entity is Directory) {
          directories++;
          walk(entity);
          continue;
        }

        if (entity is! File) {
          continue;
        }

        files++;

        if (!entity.path.endsWith('.dart')) {
          continue;
        }

        dartFiles++;

        try {
          linesOfCode += entity.readAsLinesSync().length;
        } catch (_) {
          // Якщо файл не вдалося прочитати —
          // просто пропускаємо його.
        }
      }
    }

    walk(root);

    return ProjectStats(
      root: root.path,
      directories: directories,
      files: files,
      dartFiles: dartFiles,
      linesOfCode: linesOfCode,
    );
  }

  String _name(FileSystemEntity entity) {
    return entity.uri.pathSegments.where((e) => e.isNotEmpty).last;
  }
}
