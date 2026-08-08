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

import 'cli/cli.dart';
import 'cli/command_registry.dart';
import 'commands/help_command.dart';
import 'commands/tree_command.dart';

Future<void> main(List<String> args) async {
  final registry = CommandRegistry();

  registry.register(() => HelpCommand(registry));
  registry.register(() => const TreeCommand());

  final cli = Cli(registry);

  await cli.run(args);
}