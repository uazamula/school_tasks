/// Project Tools
///
/// Єдина точка входу для всіх консольних інструментів проєкту.
///
/// Приклади:
///
/// dart run tool/project_tools.dart
/// dart run tool/project_tools.dart help
/// dart run tool/project_tools.dart h
/// dart run tool/project_tools.dart tree
/// dart run tool/project_tools.dart tree .
/// dart run tool/project_tools.dart tree tool
/// dart run tool/project_tools.dart stats lib
/// dart run tool/project_tools.dart tree --dirs --depth 2
/// dart run tool/project_tools.dart tree --files --depth 1
/// dart run tool/project_tools.dart tree . --files --depth 1
/// dart run tool/project_tools.dart tree lib/features/learning

import 'cli/cli.dart';
import 'cli/command_registry.dart';
import 'commands/help_command.dart';
import 'commands/tree_command.dart';
import 'commands/stats_command.dart';

Future<void> main(List<String> args) async {
  final registry = CommandRegistry();

  registry.register(() => HelpCommand(registry));
  registry.register(() => const TreeCommand());
  registry.register(() => const StatsCommand());

  final cli = Cli(registry);

  await cli.run(args);
}
