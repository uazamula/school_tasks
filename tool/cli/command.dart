abstract interface class Command {
  const Command();

  /// Основна назва команди.
  String get name;

  /// Скорочення команди.
  List<String> get aliases;

  /// Короткий опис.
  String get description;

  /// Як користуватися.
  String get usage;

  /// Приклад запуску.
  String get example;

  /// Опції команди.
  List<String> get options;

  /// Виконання команди.
  Future<void> run(List<String> args);
}