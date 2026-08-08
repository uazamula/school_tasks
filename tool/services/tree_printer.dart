import 'dart:io';

final class TreePrinter {
  static const _ignored = {
    '.git',
    '.dart_tool',
    '.idea',
    '.DS_Store',
    'build',
  };

  void print(Directory root) {
    stdout.writeln('${_name(root)}/');

    _walk(
      directory: root,
      prefix: '',
    );
  }

  void _walk({
    required Directory directory,
    required String prefix,
  }) {
    final entities = directory
        .listSync()
        .where(_isVisible)
        .toList()
      ..sort(_compare);

    for (var i = 0; i < entities.length; i++) {
      final entity = entities[i];

      final isLast = i == entities.length - 1;

      final branch = isLast ? '└── ' : '├── ';
      final childPrefix = prefix + (isLast ? '    ' : '│   ');

      stdout.writeln('$prefix$branch${_name(entity)}');

      if (entity is Directory) {
        _walk(
          directory: entity,
          prefix: childPrefix,
        );
      }
    }
  }

  bool _isVisible(FileSystemEntity entity) {
    final name = _name(entity);

    if (_ignored.contains(name)) {
      return false;
    }

    return !name.startsWith('.');
  }

  int _compare(
      FileSystemEntity a,
      FileSystemEntity b,
      ) {
    final aDirectory = a is Directory;
    final bDirectory = b is Directory;

    if (aDirectory != bDirectory) {
      return aDirectory ? -1 : 1;
    }

    return _name(a).compareTo(_name(b));
  }

  String _name(FileSystemEntity entity) {
    return entity.uri.pathSegments
        .where((e) => e.isNotEmpty)
        .last;
  }
}