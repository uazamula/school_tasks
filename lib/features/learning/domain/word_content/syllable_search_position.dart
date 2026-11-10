/// Determines which syllables of a word are considered.
enum SyllableSearchPosition {
  /// Any syllable in the word may match.
  any,

  /// Only the first syllable may match.
  first,

  /// Лише останній склад може збігатися.
  last,
}

extension SyllableSearchPositionSelect on SyllableSearchPosition {
  /// Склади, які розглядаються для цієї позиції.
  List<String> select(List<String> syllables) {
    if (syllables.isEmpty) return const [];

    return switch (this) {
      SyllableSearchPosition.any => syllables,
      SyllableSearchPosition.first => [syllables.first],
      SyllableSearchPosition.last => [syllables.last],
    };
  }
}
