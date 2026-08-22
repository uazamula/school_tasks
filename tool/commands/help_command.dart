// ignore_for_file: avoid_print
import '../cli/base_command.dart';
import '../cli/command.dart';
import '../cli/command_registry.dart';

final class HelpCommand extends BaseCommand {
  HelpCommand(this.registry);

  final CommandRegistry registry;

  @override
  String get name => 'help';

  @override
  List<String> get aliases => const ['h'];

  @override
  String get description => 'Show available commands';

  @override
  String get usage => 'help';

  @override
  String get example => 'dart run tool/project_tools.dart help';

  @override
  Future<void> run(List<String> args) async {
    print('Project Tools');
    print('');

    print('Usage');
    print('');
    print('  dart run tool/project_tools.dart <command> [options]');
    print('');

    print('Available commands');
    print('');

    for (final command in registry.commands) {
      _printCommand(command);

      if (command.options.isNotEmpty) {
        print('');

        for (final option in command.options) {
          print('      $option');
        }

        print('');
      }
    }

    print('');
    print('Examples');
    print('');

    for (final command in registry.commands) {
      print('  ${command.example}');
    }
  }

  void _printCommand(Command command) {
    final aliases = command.aliases.isEmpty
        ? ''
        : ' (${command.aliases.join(', ')})';

    print(
      '  ${command.name.padRight(10)} '
      '${command.description}$aliases',
    );
  }
}
