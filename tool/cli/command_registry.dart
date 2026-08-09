import 'command.dart';
import 'command_factory.dart';

class CommandRegistry {
  final Map<String, CommandFactory> _factories = {};

  void register(CommandFactory factory) {
    final command = factory();

    _factories[command.name] = factory;

    for (final alias in command.aliases) {
      _factories[alias] = factory;
    }
  }

  Command? find(String name) {
    final factory = _factories[name];

    if (factory == null) {
      return null;
    }

    return factory();
  }

  Iterable<Command> get commands {
    final uniqueFactories = _factories.values.toSet();

    final commands = uniqueFactories.map((factory) => factory()).toList();

    commands.sort((a, b) => a.name.compareTo(b.name));

    return commands;
  }
}
