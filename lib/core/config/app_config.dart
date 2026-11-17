/// Програмні перемикачі застосунку (змінюються в коді).
abstract final class AppConfig {
  const AppConfig._();

  /// Дитячий інтерфейс за замовчуванням, поки користувач нічого не обрав.
  static const kidsUiDefault = false;

  /// Чи показувати перемикач дитячого інтерфейсу в налаштуваннях.
  static const kidsUiSwitchVisible = true;
}
