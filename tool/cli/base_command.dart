import 'command.dart';

abstract base class BaseCommand implements Command {
  const BaseCommand();

  @override
  List<String> get aliases => const [];

  @override
  String get usage => name;

  @override
  String get example => 'dart run tool/project_tools.dart $name';

  @override
  List<String> get options => const [];
}
