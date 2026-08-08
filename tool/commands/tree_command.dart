import 'dart:io';

import '../cli/base_command.dart';
import '../services/tree_printer.dart';

final class TreeCommand extends BaseCommand {
  const TreeCommand();

  @override
  String get name => 'tree';

  @override
  List<String> get aliases => const ['t'];

  @override
  String get description => 'Print project tree';

  @override
  String get usage => 'tree [directory]';

  @override
  String get example => 'dart run tool/project_tools.dart tree lib';

  @override
  Future<void> run(List<String> args) async {
    final path = args.isEmpty ? 'lib' : args.first;

    final directory = Directory(path);

    if (!directory.existsSync()) {
      stderr.writeln('Directory not found: $path');
      exitCode = 1;
      return;
    }

    TreePrinter().print(directory);
  }
}