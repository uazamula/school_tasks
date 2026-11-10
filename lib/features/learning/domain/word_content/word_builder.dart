import 'content_tag.dart';
import 'language.dart';
import 'word_concept.dart';
import 'word_entry.dart';

/// Папка з картинками (відносно кореня проєкту).
const String _imagesDir = 'assets/images/';

/// Розширення за замовчуванням, якщо в назві файлу його не вказано.
const String _defaultImageExt = 'png';
const String _defaultAudioExt = 'mp3';

/// Розділювач складів у скороченому записі: 'му-ра-хи'.
const String _syllableSeparator = '-';

/// Форма слова однією мовою (сирі дані до розбору).
///
/// Створюється через [uk], [en], [tr]:
/// `uk('uk_murakhy', 'мурахи', 'му-ра-хи')`.
class LangForm {
  const LangForm(this.language, this.audio, this.word, [this.split]);

  final Language language;

  /// Назва аудіофайлу: без розширення = '.mp3'. Може бути null.
  final String? audio;

  final String word;

  /// Слово зі складами через дефіс. Може бути null.
  final String? split;
}

LangForm uk(String? audio, String word, [String? split]) =>
    LangForm(Language.uk, audio, word, split);

LangForm en(String? audio, String word, [String? split]) =>
    LangForm(Language.en, audio, word, split);

LangForm tr(String? audio, String word, [String? split]) =>
    LangForm(Language.tr, audio, word, split);

/// Результат одного виклику `word...(...)`: концепт + слова різними мовами.
class WordRecord {
  WordRecord({required this.concept, required List<WordEntry> entries})
    : entries = List.unmodifiable(entries);

  final WordConcept concept;
  final List<WordEntry> entries;

  String get id => concept.id;

  /// Слово заданою мовою або null, якщо його немає.
  WordEntry? entry(Language language) {
    for (final e in entries) {
      if (e.language == language) return e;
    }
    return null;
  }

  /// Слово заданою мовою; кидає помилку, якщо його немає.
  WordEntry entryOf(Language language) {
    final e = entry(language);
    if (e == null) {
      throw StateError('Для "$id" немає слова мовою $language');
    }
    return e;
  }

  bool hasLanguage(Language language) => entry(language) != null;
}

// ---------------------------------------------------------------------------
// Короткі конструктори
// ---------------------------------------------------------------------------

/// Одна мова — українська.
/// `wordUk('ants', 'ants', 'uk_murakhy', 'мурахи', 'му-ра-хи', {t.animal})`
WordRecord wordUk(
  String id,
  String? image,
  String? audio,
  String word, [
  String? split,
  Set<ContentTag> tags = const {},
]) => words(id, image, [uk(audio, word, split)], tags);

/// Одна мова — англійська.
WordRecord wordEn(
  String id,
  String? image,
  String? audio,
  String word, [
  String? split,
  Set<ContentTag> tags = const {},
]) => words(id, image, [en(audio, word, split)], tags);

/// Одна мова — турецька.
WordRecord wordTr(
  String id,
  String? image,
  String? audio,
  String word, [
  String? split,
  Set<ContentTag> tags = const {},
]) => words(id, image, [tr(audio, word, split)], tags);

/// Один концепт — слова кількома мовами.
///
/// `words('ants', 'ants', [uk('uk_murakhy', 'мурахи', 'му-ра-хи'),
///   en('en_ants', 'ants')], {t.animal})`
///
/// Правила:
/// - [image]: без розширення = '.png'; шлях додається автоматично; може бути null;
/// - аудіо: без розширення = '.mp3';
/// - склади через '-' перетворюються на список (без запису — порожній список).
WordRecord words(
  String id,
  String? image,
  List<LangForm> forms, [
  Set<ContentTag> tags = const {},
]) {
  assert(forms.isNotEmpty, 'Для "$id" не вказано жодної мови');
  assert(
    forms.map((f) => f.language).toSet().length == forms.length,
    'Для "$id" мова повторюється',
  );

  return WordRecord(
    concept: WordConcept(
      id: id,
      image: image == null
          ? null
          : _imagesDir + _withExt(image, _defaultImageExt),
      // Батьківські теги додаються автоматично (domesticAnimal → animal).
      tags: tags.withAncestors,
    ),
    entries: [for (final f in forms) _buildEntry(id, f)],
  );
}

// ---------------------------------------------------------------------------
// Внутрішні функції
// ---------------------------------------------------------------------------

WordEntry _buildEntry(String id, LangForm f) {
  _validateSplit(id, f);
  return WordEntry(
    conceptId: id,
    language: f.language,
    word: f.word,
    audio: f.audio == null ? null : _withExt(f.audio!, _defaultAudioExt),
    syllables: f.split == null ? const [] : f.split!.split(_syllableSeparator),
  );
}

/// Додає розширення, якщо в назві файлу його немає.
String _withExt(String name, String defaultExt) {
  final fileName = name.split('/').last;
  return fileName.contains('.') ? name : '$name.$defaultExt';
}

/// Перевірка лише в debug: склади без дефісів мають збігатися зі словом.
void _validateSplit(String id, LangForm f) {
  final split = f.split;
  if (split == null) return;
  assert(
    split.replaceAll(_syllableSeparator, '') == f.word,
    '[$id/${f.language}] Склади "$split" не збігаються зі словом "${f.word}"',
  );
  assert(
    split.split(_syllableSeparator).every((s) => s.isNotEmpty),
    '[$id/${f.language}] Порожній склад у "$split"',
  );
}
