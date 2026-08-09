import 'dart:io';

import '../cli/base_command.dart';
import '../services/project_stats.dart';
import '../services/stats_service.dart';

final class StatsCommand extends BaseCommand {
  const StatsCommand();

  @override
  String get name => 'stats';

  @override
  List<String> get aliases => const ['s'];

  @override
  String get description => 'Show project statistics';

  @override
  String get usage => 'stats [directory]';

  @override
  String get example => 'dart run tool/project_tools.dart stats lib';

  @override
  List<String> get options => const [];

  @override
  Future<void> run(List<String> args) async {
    final path = args.isEmpty ? 'lib' : args.first;

    final directory = Directory(path);

    if (!directory.existsSync()) {
      stderr.writeln('Directory not found: $path');
      exitCode = 1;
      return;
    }

    final stats = StatsService().collect(directory);

    _print(stats);
  }

  void _print(ProjectStats stats) {
    stdout.writeln('Project statistics');
    stdout.writeln('');

    stdout.writeln('Directory   : ${stats.root}');
    stdout.writeln('Directories : ${stats.directories}');
    stdout.writeln('Files       : ${stats.files}');
    stdout.writeln('Dart files  : ${stats.dartFiles}');
    stdout.writeln('Lines       : ${stats.linesOfCode}');
  }
}
