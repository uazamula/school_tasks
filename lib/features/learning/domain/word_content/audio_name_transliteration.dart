import 'language.dart';
import 'ukrainian_transliteration.dart';

/// Очікувані назви звукових файлів за мовою: слово чи склад → латиниця
/// з малих літер, цифр і `_`.
///
/// - українська: правила 2010 року ([UkrainianTransliteration]);
/// - турецька: `ö→oe`, `ü→ue`, `ı→ix`, `ç→cx`, `ş→sx`, `ğ→gx`
///   (`â→ax`, `î→iw`, `û→uw`), решта літер як є, `İ` і `i` дають `i`;
/// - англійська: нижній регістр без змін.
///
/// Для всіх мов пробіл і дефіс дають `_`, апостроф відкидається.
abstract final class AudioNameTransliteration {
  /// Очікувана назва файлу (без префікса мови й розширення).
  ///
  /// [initial] враховується лише для української: чи вважати першу літеру
  /// початком слова (є, ї, й, ю, я пишуться по-різному).
  static String transliterate(
    Language language,
    String text, {
    bool initial = true,
  }) {
    return switch (language) {
      Language.uk => UkrainianTransliteration.transliterate(
        text,
        initial: initial,
      ),
      Language.tr => _turkish(text),
      Language.en => _english(text),
    };
  }

  /// Назва набору правил для повідомлень аудиту.
  static String ruleName(Language language) {
    return switch (language) {
      Language.uk => 'за правилами 2010 року',
      Language.tr =>
        'за правилами для турецької (ö→oe, ü→ue, ı→ix, ç→cx, ş→sx, ğ→gx)',
      Language.en => 'за правилами для англійської',
    };
  }

  static const Map<String, String> _turkishLetters = {
    'ö': 'oe',
    'ü': 'ue',
    'ı': 'ix',
    'ç': 'cx',
    'ş': 'sx',
    'ğ': 'gx',
    'â': 'ax',
    'î': 'iw',
    'û': 'uw',
  };

  static const Set<String> _apostrophes = {"'", 'ʼ', '’', '‘', '`'};

  static final RegExp _latinOrDigit = RegExp(r'[a-z0-9]');

  static String _turkish(String text) {
    // Спершу «İ» і «I» за турецькими правилами, інакше toLowerCase()
    // дасть «i» з комбінованою крапкою.
    final lower = text
        .trim()
        .replaceAll('İ', 'i')
        .replaceAll('I', 'ı')
        .toLowerCase();

    return _convert(lower, _turkishLetters);
  }

  static String _english(String text) {
    return _convert(text.trim().toLowerCase(), const {});
  }

  static String _convert(String lower, Map<String, String> letters) {
    final out = StringBuffer();

    for (final c in lower.split('')) {
      if (c == ' ' || c == '-') {
        out.write('_');
        continue;
      }

      if (_apostrophes.contains(c)) continue;

      final mapped = letters[c];
      if (mapped != null) {
        out.write(mapped);
        continue;
      }

      if (_latinOrDigit.hasMatch(c)) out.write(c);
    }

    return out.toString();
  }
}
