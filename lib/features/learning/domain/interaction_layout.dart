class InteractionLayout {
  const InteractionLayout({this.scrollable = false, this.spacing = 16});

  /// Якщо true — великий контент не масштабується,
  /// а прокручується.
  ///
  /// Якщо false — великий контент масштабується,
  /// щоб уміститися в область.
  final bool scrollable;

  /// Відступ навколо контенту.
  final double spacing;
}
