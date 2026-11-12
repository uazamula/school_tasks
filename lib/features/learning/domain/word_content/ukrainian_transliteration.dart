/// Українська транслітерація за правилами 2010 року
/// (постанова КМУ № 55 від 27.01.2010, «національна»).
///
/// Особливості: літери є, ї, й, ю, я мають різний запис на початку слова
/// та в середині; «зг» дає «zgh»; м'який знак і апостроф пропускаються.
abstract final class UkrainianTransliteration {
  static const Map<String, String> _simple = {
    'а': 'a',
    'б': 'b',
    'в': 'v',
    'г': 'h',
    'ґ': 'g',
    'д': 'd',
    'е': 'e',
    'ж': 'zh',
    'з': 'z',
    'и': 'y',
    'і': 'i',
    'к': 'k',
    'л': 'l',
    'м': 'm',
    'н': 'n',
    'о': 'o',
    'п': 'p',
    'р': 'r',
    'с': 's',
    'т': 't',
    'у': 'u',
    'ф': 'f',
    'х': 'kh',
    'ц': 'ts',
    'ч': 'ch',
    'ш': 'sh',
    'щ': 'shch',
  };

  /// Символи, які пропускаються.
  static const Set<String> _dropped = {'ь', "'", 'ʼ', '’', '‘'};

  static final RegExp _latinOrDigit = RegExp(r'[a-z0-9]');

  /// Транслітерує [text] малими латинськими літерами.
  ///
  /// [initial] — чи вважати першу літеру початком слова. Для складів, що
  /// озвучуються окремо, перевіряють обидва варіанти.
  /// Пробіл і дефіс перетворюються на '_'.
  static String transliterate(String text, {bool initial = true}) {
    final chars = text.trim().toLowerCase().split('');
    final out = StringBuffer();
    var atStart = initial;

    for (var i = 0; i < chars.length; i++) {
      final c = chars[i];

      if (c == ' ' || c == '-') {
        out.write('_');
        atStart = true;
        continue;
      }

      if (_dropped.contains(c)) {
        atStart = false;
        continue;
      }

      // «зг» → «zgh», щоб відрізнити від «ж» («zh»).
      if (c == 'з' && i + 1 < chars.length && chars[i + 1] == 'г') {
        out.write('zgh');
        i++;
        atStart = false;
        continue;
      }

      final value = switch (c) {
        'є' => atStart ? 'ye' : 'ie',
        'ї' => atStart ? 'yi' : 'i',
        'й' => atStart ? 'y' : 'i',
        'ю' => atStart ? 'yu' : 'iu',
        'я' => atStart ? 'ya' : 'ia',
        _ => _simple[c] ?? (_latinOrDigit.hasMatch(c) ? c : ''),
      };

      out.write(value);
      atStart = false;
    }

    return out.toString();
  }
}
