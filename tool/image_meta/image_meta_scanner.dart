import 'dart:io';

import 'package:school_tasks/features/learning/domain/word_content/image_aspect.dart';

import 'image_size_reader.dart';

/// Папка із зображеннями (відносно кореня проєкту).
const String imagesRoot = 'assets/images';

/// Згенерований файл з розмірами.
const String imageMetaOutputPath =
    'lib/features/learning/domain/word_content/image_meta.g.dart';

/// Підтримувані розширення.
const Set<String> _supportedExtensions = {'png', 'jpg', 'jpeg'};

/// Формати, які ми не вміємо читати (про них повідомляємо).
const Set<String> _unsupportedExtensions = {'webp', 'gif', 'svg', 'bmp'};

class ImageMetaEntry {
  const ImageMetaEntry(this.path, this.width, this.height);

  /// Шлях ресурсу: `assets/images/ants.png`.
  final String path;
  final int width;
  final int height;

  double get aspect => width / height;
  int get shortSide => width < height ? width : height;
}

class ImageMetaScan {
  const ImageMetaScan(this.entries, this.problems);

  final List<ImageMetaEntry> entries;

  /// Файли, розмір яких не вдалося визначити, та інші проблеми.
  final List<String> problems;
}

/// Обходить [root] і читає розміри всіх png/jpg.
ImageMetaScan scanImages({String root = imagesRoot}) {
  final directory = Directory(root);

  if (!directory.existsSync()) {
    return ImageMetaScan(const [], [
      'Папку "$root" не знайдено. Запускайте команду з кореня проєкту.',
    ]);
  }

  final files = directory
      .listSync(recursive: true, followLinks: false)
      .whereType<File>()
      .toList();

  final entries = <ImageMetaEntry>[];
  final problems = <String>[];

  for (final file in files) {
    final path = file.path.replaceAll('\\', '/');
    final dot = path.lastIndexOf('.');
    final extension = dot < 0 ? '' : path.substring(dot + 1).toLowerCase();

    if (_unsupportedExtensions.contains(extension)) {
      problems.add('Непідтримуваний формат (потрібні png/jpg): $path');
      continue;
    }

    if (!_supportedExtensions.contains(extension)) continue;

    final size = readImageSize(file.readAsBytesSync());

    if (size == null) {
      problems.add('Не вдалося прочитати розмір (файл пошкоджений?): $path');
      continue;
    }

    entries.add(ImageMetaEntry(path, size.width, size.height));
  }

  entries.sort((a, b) => a.path.compareTo(b.path));

  return ImageMetaScan(entries, problems);
}

/// Текст згенерованого Dart-файлу.
String renderImageMetaDart(List<ImageMetaEntry> entries) {
  final buffer = StringBuffer()
    ..writeln('// dart format off')
    ..writeln('// GENERATED CODE — DO NOT EDIT.')
    ..writeln(
      '// Генерується командою: dart run tool/project_tools.dart images',
    )
    ..writeln()
    ..writeln("import 'image_meta.dart';")
    ..writeln()
    ..writeln(
      '/// Розміри зображень: шлях ресурсу → ширина і висота в пікселях.',
    )
    ..writeln('const Map<String, ImageMeta> generatedImageMeta = {');

  for (final entry in entries) {
    buffer.writeln(
      "  '${_escape(entry.path)}': ImageMeta(${entry.width}, ${entry.height}),",
    );
  }

  buffer.writeln('};');

  return buffer.toString();
}

String _escape(String value) => value
    .replaceAll(r'\', r'\\')
    .replaceAll("'", r"\'")
    .replaceAll(r'$', r'\$');

/// Розбирає раніше згенерований файл: шлях → (ширина, висота).
/// Не залежить від форматування (переносів рядків).
Map<String, (int, int)> parseImageMetaDart(String source) {
  final pattern = RegExp(
    r"'((?:[^'\\]|\\.)*)':\s*ImageMeta\(\s*(\d+),\s*(\d+)\s*\)",
  );

  return {
    for (final match in pattern.allMatches(source))
      _unescape(match.group(1)!): (
        int.parse(match.group(2)!),
        int.parse(match.group(3)!),
      ),
  };
}

String _unescape(String value) =>
    value.replaceAllMapped(RegExp(r'\\(.)'), (match) => match.group(1)!);

/// Результат порівняння файлів на диску із згенерованим файлом.
class ImageMetaCheck {
  const ImageMetaCheck({
    required this.missing,
    required this.changed,
    required this.removed,
  });

  /// Є на диску, немає в таблиці.
  final List<String> missing;

  /// Розмір у таблиці не збігається з файлом.
  final List<String> changed;

  /// Є в таблиці, але файла вже немає.
  final List<String> removed;

  bool get isUpToDate => missing.isEmpty && changed.isEmpty && removed.isEmpty;
}

/// Порівнює [scanned] із вмістом згенерованого файлу [existingSource].
ImageMetaCheck checkImageMeta(
  List<ImageMetaEntry> scanned,
  String existingSource,
) {
  final existing = parseImageMetaDart(existingSource);
  final scannedPaths = {for (final e in scanned) e.path};

  final missing = <String>[];
  final changed = <String>[];

  for (final entry in scanned) {
    final saved = existing[entry.path];

    if (saved == null) {
      missing.add(entry.path);
    } else if (saved.$1 != entry.width || saved.$2 != entry.height) {
      changed.add(entry.path);
    }
  }

  final removed = [
    for (final path in existing.keys)
      if (!scannedPaths.contains(path)) path,
  ]..sort();

  return ImageMetaCheck(missing: missing, changed: changed, removed: removed);
}

/// Підсумок по зображеннях: допомагає підібрати пороги фільтрів.
String formatImageMetaSummary(List<ImageMetaEntry> entries) {
  if (entries.isEmpty) return 'Зображень не знайдено.';

  final lines = <String>['Зображень: ${entries.length}'];

  // Пропорції.
  final aspects = entries.map((e) => e.aspect).toList()..sort();
  lines.add(
    'Співвідношення сторін (ширина/висота): '
    'від ${aspects.first.toStringAsFixed(2)} '
    'до ${aspects.last.toStringAsFixed(2)}',
  );

  var square = 0;
  var landscape = 0;
  var portrait = 0;

  for (final entry in entries) {
    if (ImageAspect.square.contains(entry.aspect)) {
      square++;
    } else if (entry.aspect > 1) {
      landscape++;
    } else {
      portrait++;
    }
  }

  lines.add(
    'Квадратні: $square, горизонтальні: $landscape, вертикальні: $portrait',
  );

  // Розподіл пропорцій із кроком 0.1.
  final histogram = <String, int>{};
  for (final entry in entries) {
    final key = ((entry.aspect * 10).round() / 10).toStringAsFixed(1);
    histogram[key] = (histogram[key] ?? 0) + 1;
  }
  final histogramKeys = histogram.keys.toList()
    ..sort((a, b) => double.parse(a).compareTo(double.parse(b)));

  lines.add(
    'Розподіл пропорцій: '
    '${histogramKeys.map((k) => '$k: ${histogram[k]}').join(', ')}',
  );

  // Роздільна здатність за меншою стороною.
  final shortSides = entries.map((e) => e.shortSide).toList()..sort();
  lines.add(
    'Менша сторона, px: мін ${shortSides.first}, '
    'медіана ${shortSides[shortSides.length ~/ 2]}, '
    'макс ${shortSides.last}',
  );

  for (final threshold in [128, 256, 512]) {
    final count = shortSides.where((s) => s < threshold).length;
    lines.add('  менша сторона < $threshold px: $count');
  }

  // Найменші зображення.
  final smallest = [...entries]
    ..sort((a, b) => a.shortSide.compareTo(b.shortSide));

  lines.add('Найменші:');
  for (final entry in smallest.take(5)) {
    lines.add('  ${entry.path}: ${entry.width}x${entry.height}');
  }

  return lines.join('\n');
}
