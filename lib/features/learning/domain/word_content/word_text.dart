/// Ключ для порівняння та пошуку: без пробілів по краях, у нижньому регістрі.
String normalizeWordKey(String value) => value.trim().toLowerCase();

final RegExp _letter = RegExp(r'\p{L}', unicode: true);

/// Кількість літер у рядку. Апострофи, дефіси та пробіли не рахуються
/// (наприклад, "зв'язок" = 6).
int countLetters(String value) => _letter.allMatches(value).length;
