import 'dart:io';

import '../commands/help_command.dart';
import 'command_registry.dart';

class Cli {
  const Cli(this.registry);

  final CommandRegistry registry;

  Future<void> run(List<String> args) async {
    if (args.isEmpty) {
      await HelpCommand(registry).run(const []);
      return;
    }

    final command = registry.find(args.first);

    if (command == null) {
      stderr.writeln('Unknown command: ${args.first}');
      stderr.writeln();

      await HelpCommand(registry).run(const []);

      exitCode = 1;
      return;
    }

    await command.run(
      args.skip(1).toList(),
    );
  }
}