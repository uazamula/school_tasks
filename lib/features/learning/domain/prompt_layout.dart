class PromptLayout {
  const PromptLayout({this.minScale = 0.75, this.spacing = 16});

  /// Мінімальний допустимий масштаб елементів.
  ///
  /// Якщо при цьому масштабі умова все одно
  /// не вміщується, використовується прокручування.
  final double minScale;

  /// Відстань між елементами умови.
  final double spacing;
}
