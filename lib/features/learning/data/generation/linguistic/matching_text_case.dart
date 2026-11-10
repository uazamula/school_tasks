enum MatchingTextCase { unchanged, uppercase, lowercase, title }

extension MatchingTextCaseFormat on MatchingTextCase {
  /// Застосовує регістр до тексту.
  String format(String text) {
    switch (this) {
      case MatchingTextCase.unchanged:
        return text;

      case MatchingTextCase.uppercase:
        return text.toUpperCase();

      case MatchingTextCase.lowercase:
        return text.toLowerCase();

      case MatchingTextCase.title:
        final value = text.toLowerCase();
        if (value.isEmpty) return value;

        return '${value[0].toUpperCase()}${value.substring(1)}';
    }
  }
}
