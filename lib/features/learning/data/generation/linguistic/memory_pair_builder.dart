import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/matching_column_element.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/matching_text_case.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/word_picture.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/memory_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/word_content/audio_paths.dart';
import 'package:school_tasks/features/learning/domain/word_content/language.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_bank.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_entry.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_filter.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_text.dart';

/// На якій картці розташоване аудіо.
enum MemoryAudioPlace {
  /// Без аудіо.
  none,

  /// Картка B (прихований вміст).
  hidden,

  /// Картка A, лицьова сторона.
  faceFront,

  /// Картка A, зворотний бік.
  faceBack,
}

/// Що озвучується.
enum MemoryAudioSource {
  /// Без аудіо.
  none,

  /// Слово (мовою [MemoryPairBuilder.audioLanguage]).
  word,

  /// Склад основної мови (той самий, що показується на картках).
  syllable,
}

/// Формує пул пар [MemoryPair] зі слів банку.
///
/// Тонкий шар поверх `WordBank` і `WordFilter`: результат `build()`
/// підставляється в `MemoryTaskData.pairPool`. Вибір конкретних пар для
/// дошки далі робить `TopicAttemptGenerator`.
///
/// Елементи карток задаються як у Matching ([MatchingColumnElement]):
/// зображення (або емодзі), слово, склад чи нічого. Аудіо прикріплюється
/// до однієї картки ([audioPlace]), щоб не виникало неоднозначності.
///
/// Мови. [language] це основна мова (М1): за нею працюють маска слова й
/// складу, склади, озвучка складів. Слово на картці та аудіо слова можуть
/// бути іншою мовою (М2): [hiddenLanguage], [faceFrontLanguage],
/// [faceBackLanguage], [audioLanguage]. Якщо не вказано, береться
/// [language]. Потрібні мови додаються у фільтр автоматично, слова без
/// перекладу відсіюються. Склади завжди основної мови.
///
/// Приклад «слово М1 + слово М2 + картинка + аудіо М2»:
/// ```dart
/// MemoryPairBuilder(
///   bank: bank,
///   minPairs: 6,
///   language: Language.uk,
///   hiddenElement: MatchingColumnElement.image,
///   faceFrontElement: MatchingColumnElement.word,
///   faceBackElement: MatchingColumnElement.word,
///   faceBackLanguage: Language.tr,
///   audioLanguage: Language.tr,
/// ).build();
/// ```
class MemoryPairBuilder {
  MemoryPairBuilder({
    required this.bank,
    required this.minPairs,
    this.filter = const WordFilter(),
    this.language = Language.uk,
    this.hiddenElement = MatchingColumnElement.image,
    this.faceFrontElement = MatchingColumnElement.word,
    this.faceBackElement = MatchingColumnElement.image,
    this.hiddenLanguage,
    this.faceFrontLanguage,
    this.faceBackLanguage,
    this.audioPlace = MemoryAudioPlace.hidden,
    this.audioSource = MemoryAudioSource.word,
    this.audioLanguage,
    this.textCase = MatchingTextCase.unchanged,
    Map<String, String> syllableAudio = const {},
    this.printDiagnostics = true,
    Random? random,
  }) : syllableAudio = Map.unmodifiable({
         for (final entry in syllableAudio.entries)
           normalizeWordKey(entry.key): entry.value,
       }),
       _random = random ?? Random() {
    if (minPairs < 1) {
      throw ArgumentError.value(minPairs, 'minPairs', 'Must be at least 1.');
    }

    _validateCard('hidden', hiddenElement, MemoryAudioPlace.hidden);
    _validateCard('faceFront', faceFrontElement, MemoryAudioPlace.faceFront);
    _validateLanguages();
  }

  final WordBank bank;
  final Random _random;

  /// Мінімальна кількість пар у пулі. Для скінченної дошки це
  /// `gridSize.pairCount`, для нескінченної пул має бути більшим за дошку,
  /// інакше дошки повторюватимуться.
  final int minPairs;

  /// Фільтр слів (теги, довжини, маска складу, візуал тощо).
  final WordFilter filter;

  /// Основна мова (М1).
  final Language language;

  /// Картка B: прихований вміст.
  final MatchingColumnElement hiddenElement;

  /// Картка A: лицьова сторона.
  final MatchingColumnElement faceFrontElement;

  /// Картка A: зворотний бік. `none` — картка A не перевертається.
  final MatchingColumnElement faceBackElement;

  /// Мова слова на картці B. null — основна.
  final Language? hiddenLanguage;

  /// Мова слова на лицьовій стороні картки A. null — основна.
  final Language? faceFrontLanguage;

  /// Мова слова на зворотному боці картки A. null — основна.
  final Language? faceBackLanguage;

  final MemoryAudioPlace audioPlace;
  final MemoryAudioSource audioSource;

  /// Мова озвучки слова. null — основна. Для озвучки складів не
  /// використовується (склади лише основної мови).
  final Language? audioLanguage;

  final MatchingTextCase textCase;

  /// Склад основної мови (нормалізований) → файл озвучки. Потрібна для
  /// [MemoryAudioSource.syllable].
  final Map<String, String> syllableAudio;

  /// Друкувати воронку відбору в консоль (лише в debug).
  final bool printDiagnostics;

  Language get _hiddenLang => hiddenLanguage ?? language;

  Language get _faceFrontLang => faceFrontLanguage ?? language;

  Language get _faceBackLang => faceBackLanguage ?? language;

  Language get _audioLang => audioLanguage ?? language;

  bool get _hasAudio =>
      audioPlace != MemoryAudioPlace.none &&
      audioSource != MemoryAudioSource.none;

  /// Чи потрібен склад: його показують на картці або озвучують.
  bool get _usesSyllable =>
      hiddenElement == MatchingColumnElement.syllable ||
      faceFrontElement == MatchingColumnElement.syllable ||
      faceBackElement == MatchingColumnElement.syllable ||
      (_hasAudio && audioSource == MemoryAudioSource.syllable);

  /// Мови, крім основної, які потрібні для слів на картках і в аудіо.
  Set<Language> get _extraLanguages => {
    if (hiddenElement == MatchingColumnElement.word) _hiddenLang,
    if (faceFrontElement == MatchingColumnElement.word) _faceFrontLang,
    if (faceBackElement == MatchingColumnElement.word) _faceBackLang,
    if (_hasAudio && audioSource == MemoryAudioSource.word) _audioLang,
  }..remove(language);

  void _validateCard(
    String name,
    MatchingColumnElement element,
    MemoryAudioPlace place,
  ) {
    final hasAudioHere = _hasAudio && audioPlace == place;

    if (element == MatchingColumnElement.none && !hasAudioHere) {
      throw ArgumentError('$name must have a visible element or audio.');
    }
  }

  /// Склади та їх озвучка завжди основної мови.
  void _validateLanguages() {
    void checkSyllableCard(
      String name,
      MatchingColumnElement element,
      Language? cardLanguage,
    ) {
      if (element == MatchingColumnElement.syllable &&
          cardLanguage != null &&
          cardLanguage != language) {
        throw ArgumentError(
          '$name: syllable cards use the main language ($language).',
        );
      }
    }

    checkSyllableCard('hiddenLanguage', hiddenElement, hiddenLanguage);
    checkSyllableCard('faceFrontLanguage', faceFrontElement, faceFrontLanguage);
    checkSyllableCard('faceBackLanguage', faceBackElement, faceBackLanguage);

    if (_hasAudio &&
        audioSource == MemoryAudioSource.syllable &&
        audioLanguage != null &&
        audioLanguage != language) {
      throw ArgumentError(
        'audioLanguage: syllable audio uses the main language ($language).',
      );
    }
  }

  /// Будує пул пар. Кидає [StateError], якщо пар менше за [minPairs].
  List<MemoryPair> build() {
    final selection = _select();

    if (kDebugMode && printDiagnostics) {
      final rules = selection.funnel.rulesReport;
      debugPrint(
        'MemoryPairs: ${selection.funnel.funnel} '
        '(потрібно пар: $minPairs)'
        '${rules.isEmpty ? '' : '\n$rules'}',
      );
    }

    if (selection.pairs.length < minPairs) {
      throw StateError(
        'Not enough suitable words to build memory pairs. '
        'Required: $minPairs, available: ${selection.pairs.length}. '
        'Funnel: ${selection.funnel.funnel}.',
      );
    }

    return List.unmodifiable(selection.pairs);
  }

  /// Воронка відбору без побудови пулу і без винятків.
  WordFilterResult diagnose() => _select().funnel;

  // ---------------------------------------------------------------------
  // Відбір слів і побудова пар
  // ---------------------------------------------------------------------

  _Selection _select() {
    final pairsById = <String, MemoryPair>{};
    final usedKeys = <String>{};

    var effectiveFilter = filter;

    // Слова без потрібного перекладу відсіюються.
    final extraLanguages = _extraLanguages;
    if (extraLanguages.isNotEmpty) {
      effectiveFilter = effectiveFilter.copyWith(
        requiredLanguages: {
          ...effectiveFilter.requiredLanguages,
          ...extraLanguages,
        },
      );
    }

    // Для озвучки складу обираємо лише серед складів, що мають озвучку.
    final needsSyllableAudio =
        _hasAudio && audioSource == MemoryAudioSource.syllable;

    if (needsSyllableAudio &&
        effectiveFilter.requireSyllableAudio == SyllableAudioRequirement.none) {
      effectiveFilter = effectiveFilter.copyWith(
        requireSyllableAudio: SyllableAudioRequirement.matching,
      );
    }

    var funnel = effectiveFilter.apply(
      bank,
      language,
      syllableAudio: syllableAudio,
    );

    // Потрібен хоча б один непорожній склад.
    if (_usesSyllable) {
      funnel = funnel.transform('склади', (m) {
        final syllables = m.syllables
            .where((s) => s.trim().isNotEmpty)
            .toList();
        return syllables.isEmpty ? null : m.withSyllables(syllables);
      });
    }

    // Картки з потрібних ресурсів: зображення, слова, аудіо тощо.
    funnel = funnel.refine('ресурси карток', (m) {
      // Той самий склад на всіх картках пари і в аудіо.
      final syllable = _usesSyllable
          ? m.syllables[_random.nextInt(m.syllables.length)]
          : null;

      final audio = _createAudio(m, syllable);
      if (_hasAudio && audio == null) return false;

      final hidden = _createCard(
        m,
        syllable,
        hiddenElement,
        _hiddenLang,
        _audioFor(MemoryAudioPlace.hidden, audio),
      );
      final front = _createCard(
        m,
        syllable,
        faceFrontElement,
        _faceFrontLang,
        _audioFor(MemoryAudioPlace.faceFront, audio),
      );

      if (hidden == null || front == null) return false;

      TaskContent? back;
      final backWanted =
          faceBackElement != MatchingColumnElement.none ||
          (_hasAudio && audioPlace == MemoryAudioPlace.faceBack);

      if (backWanted) {
        back = _createCard(
          m,
          syllable,
          faceBackElement,
          _faceBackLang,
          _audioFor(MemoryAudioPlace.faceBack, audio),
        );
        if (back == null) return false;
      }

      pairsById[m.record.id] = MemoryPair(
        id: m.record.id,
        hiddenContent: hidden,
        faceFront: front,
        faceBack: back,
      );
      return true;
    });

    // Лицьова сторона A не має збігатися з B чи зворотним боком A
    // (наприклад, однакове слово в двох мовах: radar / radar).
    // Збіг B і зворотного боку A допустимий (картинка).
    funnel = funnel.refine('збіг карток пари', (m) {
      final pair = pairsById[m.record.id]!;
      final frontKey = _contentKey(pair.faceFront);

      if (frontKey == _contentKey(pair.hiddenContent)) return false;

      final back = pair.faceBack;
      if (back != null && frontKey == _contentKey(back)) return false;

      return true;
    });

    // Видимий вміст карток не повторюється між парами: однакові картки
    // (однакове слово, склад, зображення чи емодзі) плутають гравця.
    funnel = funnel.refine('унікальність карток', (m) {
      final pair = pairsById[m.record.id]!;

      final keys = {
        _contentKey(pair.hiddenContent),
        _contentKey(pair.faceFront),
        if (pair.faceBack != null) _contentKey(pair.faceBack!),
      };

      if (keys.any(usedKeys.contains)) return false;

      usedKeys.addAll(keys);
      return true;
    });

    return _Selection(
      funnel: funnel,
      pairs: [for (final m in funnel.matches) pairsById[m.record.id]!],
    );
  }

  // ---------------------------------------------------------------------
  // Контент
  // ---------------------------------------------------------------------

  /// Слово потрібною мовою: основна беремо з відбору, іншу з запису.
  WordEntry? _entryFor(WordMatch match, Language lang) =>
      lang == language ? match.entry : match.record.entry(lang);

  AudioContent? _audioFor(MemoryAudioPlace place, AudioContent? audio) =>
      _hasAudio && audioPlace == place ? audio : null;

  AudioContent? _createAudio(WordMatch match, String? syllable) {
    if (!_hasAudio) return null;

    final file = switch (audioSource) {
      MemoryAudioSource.word => _entryFor(match, _audioLang)?.audio,
      MemoryAudioSource.syllable =>
        syllable == null ? null : syllableAudio[normalizeWordKey(syllable)],
      MemoryAudioSource.none => null,
    };

    final path = file?.trim();

    if (path == null || path.isEmpty) return null;

    return AudioContent.fixed(AudioPaths.resolvePronunciation(path));
  }

  /// Контент однієї картки. Якщо елемента немає, але є аудіо, картка стає
  /// самостійним аудіо. Повертає null, якщо бракує потрібного ресурсу
  /// (або картки немає взагалі).
  TaskContent? _createCard(
    WordMatch match,
    String? syllable,
    MatchingColumnElement element,
    Language cardLanguage,
    AudioContent? audio,
  ) {
    switch (element) {
      case MatchingColumnElement.none:
        return audio;

      case MatchingColumnElement.image:
        return createPictureContent(
          match.concept,
          audio: audio,
          source: filter.pictureSource,
        );

      case MatchingColumnElement.word:
        final entry = _entryFor(match, cardLanguage);
        if (entry == null) return null;

        return TextContent(
          textCase.format(entry.word, cardLanguage),
          audio: audio,
        );

      case MatchingColumnElement.syllable:
        if (syllable == null) return null;

        return TextContent(textCase.format(syllable, language), audio: audio);
    }
  }

  /// Ключ видимого вмісту картки (аудіо до уваги не береться).
  static String _contentKey(TaskContent content) {
    return switch (content) {
      TextContent(:final text) => 't:$text',
      ImageContent(:final imagePath) => 'i:$imagePath',
      EmojiContent(:final emoji) => 'e:$emoji',
      _ => 'o:${content.hashCode}',
    };
  }
}

/// Результат відбору: воронка та готові пари.
class _Selection {
  const _Selection({required this.funnel, required this.pairs});

  final WordFilterResult funnel;
  final List<MemoryPair> pairs;
}
