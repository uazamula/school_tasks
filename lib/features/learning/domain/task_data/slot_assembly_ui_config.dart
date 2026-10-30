
class SlotAssemblyUiConfig {
  const SlotAssemblyUiConfig({
    this.bubbleFontSizeFactor = 1.5,
    this.slotWidthPerCharacter = 26.0,
    this.bubbleHeight = 60.0,
    this.slotHeight = 56.0,
    this.bubbleExpandsHorizontally = false,
  });

  /// Множник розміру шрифту titleMedium для тексту в бульбашці.
  final double bubbleFontSizeFactor;

  /// Ширина слота на один ефективний символ.
  /// Підрядкові цифри враховуються як 0.5 символу.
  final double slotWidthPerCharacter;

  /// Висота круглої бульбашки.
  final double bubbleHeight;

  /// Мінімальна висота слота.
  final double slotHeight;

  /// Чи може бульбашка розширюватися горизонтально.
  /// Поки підтримується лише false.
  final bool bubbleExpandsHorizontally;
}
