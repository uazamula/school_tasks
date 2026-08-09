import 'dart:io';

import '../cli/base_command.dart';
import '../services/tree_options.dart';
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
  String get usage => 'tree [directory] [--dirs] [--files] [--depth N]';

  @override
  String get example => 'dart run tool/project_tools.dart tree lib --depth 2';

  @override
  List<String> get options => const [
    '--dirs        Show directories only',
    '--files       Show files only',
    '--depth N     Limit recursion depth',
  ];

  @override
  Future<void> run(List<String> args) async {
    var path = 'lib';

    var showDirectories = true;
    var showFiles = true;
    int? maxDepth;

    for (var i = 0; i < args.length; i++) {
      final arg = args[i];

      switch (arg) {
        case '--dirs':
          showFiles = false;
          break;

        case '--files':
          showDirectories = false;
          break;

        case '--depth':
          if (i + 1 >= args.length) {
            stderr.writeln('Missing value after --depth');
            exitCode = 1;
            return;
          }

          maxDepth = int.tryParse(args[++i]);

          if (maxDepth == null || maxDepth < 0) {
            stderr.writeln('Invalid depth value.');
            exitCode = 1;
            return;
          }

          break;

        default:
          if (!arg.startsWith('--')) {
            path = arg;
          } else {
            stderr.writeln('Unknown option: $arg');
            exitCode = 1;
            return;
          }
      }
    }

    final directory = Directory(path);

    if (!directory.existsSync()) {
      stderr.writeln('Directory not found: $path');
      exitCode = 1;
      return;
    }

    final options = TreeOptions(
      root: directory,
      showDirectories: showDirectories,
      showFiles: showFiles,
      maxDepth: maxDepth,
    );

    TreePrinter().print(options);
  }
}
