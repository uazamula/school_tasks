import 'dart:io';

import 'tree_options.dart';

final class TreePrinter {
  static const _ignored = {
    '.dart_tool',
    '.git',
    '.idea',
    '.DS_Store',
    'build',
  };

  void print(TreeOptions options) {
    stdout.writeln('${_name(options.root)}/');

    if (options.showDirectories) {
      _printDirectories(
        directory: options.root,
        options: options,
        prefix: '',
        depth: 0,
      );
    } else {
      _printFilesOnly(
        directory: options.root,
        options: options,
        depth: 0,
      );
    }
  }

  void _printDirectories({
    required Directory directory,
    required TreeOptions options,
    required String prefix,
    required int depth,
  }) {
    if (options.maxDepth != null && depth >= options.maxDepth!) {
      return;
    }

    final directories = <Directory>[];
    final files = <File>[];

    for (final entity in directory.listSync()) {
      if (!_isVisible(entity)) {
        continue;
      }

      if (entity is Directory) {
        directories.add(entity);
      } else if (entity is File) {
        files.add(entity);
      }
    }

    directories.sort((a, b) => _name(a).compareTo(_name(b)));
    files.sort((a, b) => _name(a).compareTo(_name(b)));

    final visible = <FileSystemEntity>[
      ...directories,
      if (options.showFiles) ...files,
    ];

    for (var i = 0; i < visible.length; i++) {
      final entity = visible[i];

      final isLast = i == visible.length - 1;

      final branch = isLast ? '└── ' : '├── ';
      final childPrefix = prefix + (isLast ? '    ' : '│   ');

      if (entity is Directory) {
        stdout.writeln('$prefix$branch${_name(entity)}/');

        _printDirectories(
          directory: entity,
          options: options,
          prefix: childPrefix,
          depth: depth + 1,
        );
      } else {
        stdout.writeln('$prefix$branch${_name(entity)}');
      }
    }
  }

  void _printFilesOnly({
    required Directory directory,
    required TreeOptions options,
    required int depth,
  }) {
    if (options.maxDepth != null && depth >= options.maxDepth!) {
      return;
    }

    final entities = directory.listSync().toList()
      ..sort((a, b) => _name(a).compareTo(_name(b)));

    for (final entity in entities) {
      if (!_isVisible(entity)) {
        continue;
      }

      if (entity is File) {
        stdout.writeln(_relativePath(
          options.root.path,
          entity.path,
        ));
      }

      if (entity is Directory) {
        _printFilesOnly(
          directory: entity,
          options: options,
          depth: depth + 1,
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

  String _name(FileSystemEntity entity) {
    return entity.uri.pathSegments
        .where((e) => e.isNotEmpty)
        .last;
  }

  String _relativePath(
      String root,
      String path,
      ) {
    final normalizedRoot = root.endsWith(Platform.pathSeparator)
        ? root
        : '$root${Platform.pathSeparator}';

    return path.startsWith(normalizedRoot)
        ? path.substring(normalizedRoot.length)
        : path;
  }
}