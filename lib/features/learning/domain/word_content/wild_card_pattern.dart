/// Порівняння рядка з маскою.
///
/// - без урахування регістру;
/// - `*` — будь-яка послідовність, включно з порожньою;
/// - `?` — рівно один символ (Unicode code point).
abstract final class WildcardPattern {
  static bool matches(String value, String pattern) {
    final text = value.trim().toLowerCase().runes.toList();
    final mask = pattern.trim().toLowerCase().runes.toList();

    var textIndex = 0;
    var maskIndex = 0;
    var lastStarIndex = -1;
    var retryTextIndex = 0;

    while (textIndex < text.length) {
      if (maskIndex < mask.length &&
          (mask[maskIndex] == 0x3F || mask[maskIndex] == text[textIndex])) {
        // '?' або точний збіг символу.
        maskIndex++;
        textIndex++;
      } else if (maskIndex < mask.length && mask[maskIndex] == 0x2A) {
        // Запам'ятовуємо '*', щоб за потреби він поглинув ще символ.
        lastStarIndex = maskIndex;
        retryTextIndex = textIndex;
        maskIndex++;
      } else if (lastStarIndex != -1) {
        // Останній '*' поглинає ще один символ.
        maskIndex = lastStarIndex + 1;
        retryTextIndex++;
        textIndex = retryTextIndex;
      } else {
        return false;
      }
    }

    // Кінцеві '*' можуть відповідати порожній послідовності.
    while (maskIndex < mask.length && mask[maskIndex] == 0x2A) {
      maskIndex++;
    }

    return maskIndex == mask.length;
  }
}
