import 'dart:math';

import 'content_tag.dart';
import 'int_range.dart';
import 'language.dart';
import 'syllable_search_position.dart';
import 'wildcard_pattern.dart';
import 'word_bank.dart';
import 'word_builder.dart';
import 'word_concept.dart';
import 'word_entry.dart';
import 'word_text.dart';

/// Яких складів потрібна озвучка в `syllableAudio`.
enum SyllableAudioRequirement {
  /// Озвучка складів не перевіряється.
  none,

  /// Озвучка потрібна лише для складів, що збіглися з маскою
  /// (достатньо для Matching: береться один склад).
  matching,

  /// Озвучка потрібна для всіх складів слова (потрібно для SlotAssembly).
  all,
}

/// Слово, що пройшло (або проходить) фільтр.
class WordMatch {
  const WordMatch({
    required this.record,
    required this.entry,
    required this.syllables,
  });

  final WordRecord record;

  /// Слово потрібною мовою.
  final WordEntry entry;

  /// Склади, що пройшли правила складів. Якщо правил складів немає,
  /// це всі склади слова. Для Matching — кандидати для вибору.
  final List<String> syllables;

  WordConcept get concept => record.concept;

  WordMatch withSyllables(List<String> value) =>
      WordMatch(record: record, entry: entry, syllables: value);
}

/// Один етап воронки: назва правила та кількість слів, що лишилися.
class WordFilterStage {
  const WordFilterStage(this.name, this.remaining);

  final String name;
  final int remaining;
}

/// Іменоване правило фільтра. Повертає слово (можливо, зі зміненим
/// списком складів) або null, якщо слово не проходить.
class WordFilterRule {
  const WordFilterRule(this.name, this.apply);

  final String name;
  final WordMatch? Function(WordMatch match) apply;
}

/// Результат фільтрації: слова, що пройшли, і воронка відбору.
class WordFilterResult {
  WordFilterResult({
    required List<WordMatch> matches,
    required List<WordFilterStage> stages,
    List<WordFilterStage> ruleCounts = const [],
  }) : matches = List.unmodifiable(matches),
       stages = List.unmodifiable(stages),
       ruleCounts = List.unmodifiable(ruleCounts);

  final List<WordMatch> matches;
  final List<WordFilterStage> stages;

  /// Скільки слів мови проходить кожне правило окремо (незалежно від
  /// інших). Показує, яке правило найжорсткіше.
  final List<WordFilterStage> ruleCounts;

  bool get isEmpty => matches.isEmpty;

  /// Воронка одним рядком: `uk: 40 → теги: 12 → патерн складу: 6`.
  String get funnel =>
      stages.map((s) => '${s.name}: ${s.remaining}').join(' → ');

  /// Кожне правило окремо одним рядком: `окремо: теги: 12, патерн складу: 20`.
  /// Порожній рядок, якщо правил немає.
  String get rulesReport {
    if (ruleCounts.isEmpty) return '';

    final parts = ruleCounts.map((s) => '${s.name}: ${s.remaining}');
    return 'окремо: ${parts.join(', ')}';
  }

  /// Додатковий етап від генератора (наприклад, «ресурси цілі»):
  /// лишає слова, для яких [keep] повертає true, і дописує етап у воронку.
  WordFilterResult refine(String name, bool Function(WordMatch) keep) {
    final kept = [
      for (final m in matches)
        if (keep(m)) m,
    ];

    return WordFilterResult(
      matches: kept,
      stages: [...stages, WordFilterStage(name, kept.length)],
      ruleCounts: ruleCounts,
    );
  }

  /// Те саме, що [refine], але з можливістю змінити слово (наприклад,
  /// звузити список складів) або відхилити його, повернувши null.
  WordFilterResult transform(
    String name,
    WordMatch? Function(WordMatch) convert,
  ) {
    final kept = <WordMatch>[];
    for (final m in matches) {
      final converted = convert(m);
      if (converted != null) kept.add(converted);
    }

    return WordFilterResult(
      matches: kept,
      stages: [...stages, WordFilterStage(name, kept.length)],
      ruleCounts: ruleCounts,
    );
  }
}

/// Спільний фільтр слів для генераторів завдань.
///
/// Усі параметри необов'язкові: незаданий параметр правило не вмикає.
/// Мова задається під час виклику [apply].
class WordFilter {
  const WordFilter({
    this.wordPattern,
    this.wordLength,
    this.syllableCount,
    this.longestSyllableLength,
    this.syllablePattern,
    this.position = SyllableSearchPosition.any,
    this.requireSyllableAudio = SyllableAudioRequirement.none,
    this.tagsAnyOf = const {},
    this.tagsAllOf = const {},
    this.tagsNoneOf = const {},
    this.includeIds = const {},
    this.excludeIds = const {},
  });

  /// Маска всього слова (`к*`, `??р*`).
  final String? wordPattern;

  /// Кількість літер у слові (без апострофів і дефісів).
  final IntRange? wordLength;

  /// Кількість складів.
  final IntRange? syllableCount;

  /// Довжина (у літерах) найдовшого складу слова.
  final IntRange? longestSyllableLength;

  /// Маска складу: слово проходить, якщо хоча б один склад збігається.
  final String? syllablePattern;

  /// Які склади розглядаються під час перевірки [syllablePattern].
  /// Без [syllablePattern] не впливає.
  final SyllableSearchPosition position;

  /// Вимоги до озвучки складів (потребує мапи `syllableAudio` у [apply]).
  final SyllableAudioRequirement requireSyllableAudio;

  /// Слово має мати хоча б один із цих тегів.
  final Set<ContentTag> tagsAnyOf;

  /// Слово має мати всі ці теги.
  final Set<ContentTag> tagsAllOf;

  /// Слово не має мати жодного з цих тегів.
  final Set<ContentTag> tagsNoneOf;

  /// Якщо не порожній — дозволені лише ці id концептів.
  final Set<String> includeIds;

  /// Виключені id концептів.
  final Set<String> excludeIds;

  /// Копія з заміною вказаних полів. Скинути поле в null не можна.
  WordFilter copyWith({
    String? wordPattern,
    IntRange? wordLength,
    IntRange? syllableCount,
    IntRange? longestSyllableLength,
    String? syllablePattern,
    SyllableSearchPosition? position,
    SyllableAudioRequirement? requireSyllableAudio,
    Set<ContentTag>? tagsAnyOf,
    Set<ContentTag>? tagsAllOf,
    Set<ContentTag>? tagsNoneOf,
    Set<String>? includeIds,
    Set<String>? excludeIds,
  }) {
    return WordFilter(
      wordPattern: wordPattern ?? this.wordPattern,
      wordLength: wordLength ?? this.wordLength,
      syllableCount: syllableCount ?? this.syllableCount,
      longestSyllableLength:
          longestSyllableLength ?? this.longestSyllableLength,
      syllablePattern: syllablePattern ?? this.syllablePattern,
      position: position ?? this.position,
      requireSyllableAudio: requireSyllableAudio ?? this.requireSyllableAudio,
      tagsAnyOf: tagsAnyOf ?? this.tagsAnyOf,
      tagsAllOf: tagsAllOf ?? this.tagsAllOf,
      tagsNoneOf: tagsNoneOf ?? this.tagsNoneOf,
      includeIds: includeIds ?? this.includeIds,
      excludeIds: excludeIds ?? this.excludeIds,
    );
  }

  /// Застосовує фільтр до банку слів.
  ///
  /// [syllableAudio] — мапа «склад → файл», потрібна лише якщо
  /// [requireSyllableAudio] не `none`.
  WordFilterResult apply(
    WordBank bank,
    Language language, {
    Map<String, String> syllableAudio = const {},
  }) {
    _validate();

    // Склади, для яких є непорожній шлях до озвучки.
    final audioKeys = <String>{
      for (final e in syllableAudio.entries)
        if (e.key.trim().isNotEmpty && e.value.trim().isNotEmpty)
          normalizeWordKey(e.key),
    };

    var current = <WordMatch>[
      for (final record in bank.records)
        if (record.entry(language) case final entry?)
          WordMatch(record: record, entry: entry, syllables: entry.syllables),
    ];

    final stages = <WordFilterStage>[
      WordFilterStage(language.name, current.length),
    ];

    final activeRules = rules(audioKeys);
    final initial = current;

    // Кожне правило окремо на всіх словах мови.
    final ruleCounts = [
      for (final rule in activeRules)
        WordFilterStage(
          rule.name,
          initial.where((m) => rule.apply(m) != null).length,
        ),
    ];

    for (final rule in activeRules) {
      final next = <WordMatch>[];

      for (final match in current) {
        final result = rule.apply(match);
        if (result != null) next.add(result);
      }

      current = next;
      stages.add(WordFilterStage(rule.name, current.length));
    }

    return WordFilterResult(
      matches: current,
      stages: stages,
      ruleCounts: ruleCounts,
    );
  }

  /// Назва першого правила, яке слово не проходить; null — слово проходить
  /// усі правила. Зручно при налагодженні даних: чому "ants" не потрапило
  /// у вибірку.
  String? explain(
    WordBank bank,
    Language language,
    String conceptId, {
    Map<String, String> syllableAudio = const {},
  }) {
    final record = bank.byId(conceptId);
    if (record == null) return 'немає слова з id "$conceptId" у банку';

    final entry = record.entry(language);
    if (entry == null) return 'немає слова мовою ${language.name}';

    final audioKeys = <String>{
      for (final e in syllableAudio.entries)
        if (e.key.trim().isNotEmpty && e.value.trim().isNotEmpty)
          normalizeWordKey(e.key),
    };

    var match = WordMatch(
      record: record,
      entry: entry,
      syllables: entry.syllables,
    );

    for (final rule in rules(audioKeys)) {
      final next = rule.apply(match);
      if (next == null) return rule.name;
      match = next;
    }

    return null;
  }

  /// Активні правила в порядку застосування. Незадані параметри
  /// правил не створюють.
  ///
  /// [syllableAudioKeys] — нормалізовані склади, що мають озвучку.
  List<WordFilterRule> rules([Set<String> syllableAudioKeys = const {}]) {
    final rules = <WordFilterRule>[];

    if (includeIds.isNotEmpty || excludeIds.isNotEmpty) {
      rules.add(
        WordFilterRule('id', (m) {
          final id = m.record.id;
          if (includeIds.isNotEmpty && !includeIds.contains(id)) return null;
          if (excludeIds.contains(id)) return null;
          return m;
        }),
      );
    }

    if (tagsAnyOf.isNotEmpty || tagsAllOf.isNotEmpty || tagsNoneOf.isNotEmpty) {
      rules.add(
        WordFilterRule('теги', (m) {
          final tags = m.concept.tags;
          if (tagsAnyOf.isNotEmpty && !tagsAnyOf.any(tags.contains)) {
            return null;
          }
          if (!tags.containsAll(tagsAllOf)) return null;
          if (tagsNoneOf.any(tags.contains)) return null;
          return m;
        }),
      );
    }

    final wordMask = wordPattern;
    if (wordMask != null) {
      rules.add(
        WordFilterRule(
          'патерн слова',
          (m) => WildcardPattern.matches(m.entry.word, wordMask) ? m : null,
        ),
      );
    }

    final lengthRange = wordLength;
    if (lengthRange != null) {
      rules.add(
        WordFilterRule(
          'довжина слова',
          (m) => lengthRange.contains(countLetters(m.entry.word)) ? m : null,
        ),
      );
    }

    final countRange = syllableCount;
    if (countRange != null) {
      rules.add(
        WordFilterRule(
          'кількість складів',
          (m) => countRange.contains(m.entry.syllables.length) ? m : null,
        ),
      );
    }

    final longestRange = longestSyllableLength;
    if (longestRange != null) {
      rules.add(
        WordFilterRule('довжина складу', (m) {
          final longest = m.entry.syllables.map(countLetters).fold<int>(0, max);
          return longestRange.contains(longest) ? m : null;
        }),
      );
    }

    final syllableMask = syllablePattern;
    if (syllableMask != null) {
      rules.add(
        WordFilterRule('патерн складу', (m) {
          final found = [
            for (final s in position.select(m.entry.syllables))
              if (s.trim().isNotEmpty &&
                  WildcardPattern.matches(s, syllableMask))
                s,
          ];
          return found.isEmpty ? null : m.withSyllables(found);
        }),
      );
    }

    bool hasAudio(String syllable) =>
        syllableAudioKeys.contains(normalizeWordKey(syllable));

    switch (requireSyllableAudio) {
      case SyllableAudioRequirement.none:
        break;

      case SyllableAudioRequirement.matching:
        rules.add(
          WordFilterRule('аудіо складів', (m) {
            final withAudio = m.syllables.where(hasAudio).toList();
            return withAudio.isEmpty ? null : m.withSyllables(withAudio);
          }),
        );

      case SyllableAudioRequirement.all:
        rules.add(
          WordFilterRule(
            'аудіо складів',
            (m) =>
                m.entry.syllables.isNotEmpty &&
                    m.entry.syllables.every(hasAudio)
                ? m
                : null,
          ),
        );
    }

    return rules;
  }

  /// Перевірка параметрів (порожні маски є помилкою конфігурації).
  void _validate() {
    if (wordPattern != null && wordPattern!.trim().isEmpty) {
      throw ArgumentError.value(
        wordPattern,
        'wordPattern',
        'Must not be empty.',
      );
    }

    if (syllablePattern != null && syllablePattern!.trim().isEmpty) {
      throw ArgumentError.value(
        syllablePattern,
        'syllablePattern',
        'Must not be empty.',
      );
    }
  }
}
