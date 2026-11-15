import 'package:school_tasks/features/learning/domain/word_content/language.dart';

enum MatchingTextCase { unchanged, uppercase, lowercase, title }

extension MatchingTextCaseFormat on MatchingTextCase {
  /// Застосовує регістр до тексту.
  ///
  /// [language] потрібна для мов зі спеціальними правилами регістру
  /// (у турецькій `i` ↔ `İ`, `ı` ↔ `I`). Без неї діють стандартні правила.
  String format(String text, [Language? language]) {
    switch (this) {
      case MatchingTextCase.unchanged:
        return text;

      case MatchingTextCase.uppercase:
        return _upper(text, language);

      case MatchingTextCase.lowercase:
        return _lower(text, language);

      case MatchingTextCase.title:
        final value = _lower(text, language);
        if (value.isEmpty) return value;

        return '${_upper(value.substring(0, 1), language)}'
            '${value.substring(1)}';
    }
  }
}

String _upper(String text, Language? language) {
  if (language == Language.tr) {
    return text.replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();
  }

  return text.toUpperCase();
}

String _lower(String text, Language? language) {
  if (language == Language.tr) {
    return text.replaceAll('I', 'ı').replaceAll('İ', 'i').toLowerCase();
  }

  return text.toLowerCase();
}
