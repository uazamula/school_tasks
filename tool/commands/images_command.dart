import 'dart:io';

import '../cli/base_command.dart';
import '../image_meta/image_meta_scanner.dart';

final class ImagesCommand extends BaseCommand {
  const ImagesCommand();

  @override
  String get name => 'images';

  @override
  List<String> get aliases => const ['img'];

  @override
  String get description =>
      'Generate image size table (aspect ratio, resolution)';

  @override
  String get usage => 'images [--report] [--check]';

  @override
  String get example => 'dart run tool/project_tools.dart images --report';

  @override
  List<String> get options => const [
    '--report      Print summary only, do not write the file',
    '--check       Verify the generated file is up to date (exit code 1 if not)',
  ];

  @override
  Future<void> run(List<String> args) async {
    var reportOnly = false;
    var checkOnly = false;

    for (final arg in args) {
      switch (arg) {
        case '--report':
          reportOnly = true;
          break;

        case '--check':
          checkOnly = true;
          break;

        default:
          stderr.writeln('Unknown option: $arg');
          exitCode = 1;
          return;
      }
    }

    if (reportOnly && checkOnly) {
      stderr.writeln('Options --report and --check cannot be combined.');
      exitCode = 1;
      return;
    }

    if (!Directory(imagesRoot).existsSync()) {
      stderr.writeln(
        'Directory not found: $imagesRoot (run from the project root).',
      );
      exitCode = 1;
      return;
    }

    final scan = scanImages();

    for (final problem in scan.problems) {
      stderr.writeln('Warning: $problem');
    }

    if (checkOnly) {
      _check(scan);
      return;
    }

    if (reportOnly) {
      stdout.writeln(formatImageMetaSummary(scan.entries));
      return;
    }

    final file = File(imageMetaOutputPath);

    if (!file.parent.existsSync()) {
      stderr.writeln('Directory not found: ${file.parent.path}');
      exitCode = 1;
      return;
    }

    file.writeAsStringSync(renderImageMetaDart(scan.entries));

    stdout.writeln(
      'Written: $imageMetaOutputPath (${scan.entries.length} images)',
    );
    stdout.writeln();
    stdout.writeln(formatImageMetaSummary(scan.entries));
  }

  void _check(ImageMetaScan scan) {
    final file = File(imageMetaOutputPath);

    if (!file.existsSync()) {
      stderr.writeln('File not found: $imageMetaOutputPath');
      stderr.writeln('Run: dart run tool/project_tools.dart images');
      exitCode = 1;
      return;
    }

    final result = checkImageMeta(scan.entries, file.readAsStringSync());

    if (result.isUpToDate && scan.problems.isEmpty) {
      stdout.writeln(
        'Image table is up to date (${scan.entries.length} images).',
      );
      return;
    }

    if (!result.isUpToDate) {
      _printList('Missing in table', result.missing);
      _printList('Size changed', result.changed);
      _printList('Removed from disk', result.removed);

      stderr.writeln('Image table is out of date.');
      stderr.writeln('Run: dart run tool/project_tools.dart images');
    }

    exitCode = 1;
  }

  void _printList(String title, List<String> items) {
    if (items.isEmpty) return;

    const limit = 20;

    stderr.writeln('$title (${items.length}):');

    for (final item in items.take(limit)) {
      stderr.writeln('  $item');
    }

    if (items.length > limit) {
      stderr.writeln('  ... and ${items.length - limit} more');
    }
  }
}
