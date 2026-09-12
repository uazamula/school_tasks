class TopicLayout {
  const TopicLayout({this.promptFlex = 1, this.interactionFlex = 2});

  /// Відносний розмір області умови.
  final int promptFlex;

  /// Відносний розмір області взаємодії.
  final int interactionFlex;

  /// Співвідношення 1/3 : 2/3.
  const TopicLayout.standard() : promptFlex = 1, interactionFlex = 2;

  /// Співвідношення 3/5 : 2/5.
  ///
  /// Для тем, де умова займає більше місця.
  const TopicLayout.largePrompt() : promptFlex = 3, interactionFlex = 2;

  /// Співвідношення 1/5 : 4/5.
  ///
  /// Наприклад, для тем, що складаються переважно з matching.
  const TopicLayout.minimalPrompt() : promptFlex = 1, interactionFlex = 4;

  int get totalFlex => promptFlex + interactionFlex;

  double get promptRatio => promptFlex / totalFlex;

  double get interactionRatio => interactionFlex / totalFlex;
}
