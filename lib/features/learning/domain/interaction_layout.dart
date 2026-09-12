class InteractionLayout {
  const InteractionLayout({this.minScale = 0.75, this.spacing = 16});

  /// Мінімальний допустимий масштаб елементів.
  ///
  /// Якщо при цьому масштабі взаємодія все одно
  /// не вміщується, використовується прокручування.
  final double minScale;

  /// Відстань між елементами взаємодії.
  final double spacing;
}
