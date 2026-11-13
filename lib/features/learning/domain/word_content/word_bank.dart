import 'content_tag.dart';
import 'language.dart';
import 'word_builder.dart';
import 'word_concept.dart';
import 'word_entry.dart';

/// Набір слів з індексом за id та зручними вибірками
/// для конструювання завдань і генераторів.
class WordBank {
  WordBank._(this._byId);

  /// Створює банк зі списку записів. У debug перевіряє унікальність id.
  factory WordBank(Iterable<WordRecord> records) {
    final map = <String, WordRecord>{};
    for (final r in records) {
      assert(!map.containsKey(r.id), 'Дублікат id концепту: "${r.id}"');
      map[r.id] = r;
    }
    return WordBank._(Map.unmodifiable(map));
  }

  /// Тимчасовий міст зі старого формату (окремі списки слів і концептів).
  /// Слова без концепту отримують синтетичний id `мова:слово`.
  factory WordBank.fromLegacy({
    required Iterable<WordEntry> words,
    required Iterable<WordConcept> concepts,
  }) {
    final conceptsById = {for (final c in concepts) c.id: c};
    final recordConcepts = <String, WordConcept>{};
    final recordEntries = <String, List<WordEntry>>{};

    for (final word in words) {
      final conceptId = word.conceptId ?? '${word.language.name}:${word.word}';
      final concept = conceptsById[conceptId] ?? WordConcept(id: conceptId);

      recordConcepts.putIfAbsent(conceptId, () => concept);
      recordEntries.putIfAbsent(conceptId, () => []).add(word);
    }

    return WordBank([
      for (final id in recordConcepts.keys)
        WordRecord(concept: recordConcepts[id]!, entries: recordEntries[id]!),
    ]);
  }

  final Map<String, WordRecord> _byId;

  /// Усі записи в порядку додавання.
  List<WordRecord> get records => _byId.values.toList(growable: false);

  /// Усі концепти (замінює старий список `...Concepts`).
  List<WordConcept> get concepts => [for (final r in _byId.values) r.concept];

  /// Усі слова всіх мов (замінює старий список `WordEntry`).
  List<WordEntry> get entries => [for (final r in _byId.values) ...r.entries];

  /// Запис за id; null, якщо немає.
  WordRecord? byId(String id) => _byId[id];

  /// Запис за id; кидає помилку, якщо немає.
  WordRecord operator [](String id) {
    final r = _byId[id];
    if (r == null) throw StateError('Немає слова з id "$id"');
    return r;
  }

  /// Записи, які мають слово заданою мовою.
  List<WordRecord> inLanguage(Language language) => [
    for (final r in _byId.values)
      if (r.hasLanguage(language)) r,
  ];

  /// Записи з тегом [tag] (за потреби — лише з мовою [language]).
  List<WordRecord> withTag(ContentTag tag, {Language? language}) => [
    for (final r in _byId.values)
      if (r.concept.tags.contains(tag) &&
          (language == null || r.hasLanguage(language)))
        r,
  ];

  /// Записи, що мають усі теги з [tags].
  List<WordRecord> withAllTags(Set<ContentTag> tags, {Language? language}) => [
    for (final r in _byId.values)
      if (r.concept.tags.containsAll(tags) &&
          (language == null || r.hasLanguage(language)))
        r,
  ];

  /// Записи із зображенням або емодзі (для завдань «картинка → слово»).
  List<WordRecord> withImage({Language? language}) => [
    for (final r in _byId.values)
      if (r.concept.hasPicture && (language == null || r.hasLanguage(language)))
        r,
  ];

  /// Записи, у яких слово має склади (для завдань на поділ на склади).
  List<WordRecord> withSyllables(Language language) => [
    for (final r in _byId.values)
      if (r.entry(language)?.syllables.isNotEmpty ?? false) r,
  ];
}
