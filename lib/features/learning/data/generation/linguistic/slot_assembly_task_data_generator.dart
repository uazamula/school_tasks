import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/matching_text_case.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/word_picture.dart';
import 'package:school_tasks/features/learning/data/generation/task_data_generator.dart';
import 'package:school_tasks/features/learning/domain/task_data/slot_assembly_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/slot_assembly_ui_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/target_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/slot_assembly_interaction_mode.dart';
import 'package:school_tasks/features/learning/domain/word_content/audio_paths.dart';
import 'package:school_tasks/features/learning/domain/word_content/language.dart';
import 'package:school_tasks/features/learning/domain/word_content/wildcard_pattern.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_bank.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_entry.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_filter.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_text.dart';

enum SlotAssemblyTargetType {
  image,
  word,
  imageWithAudio,
  wordWithAudio,
  audio,
}

/// Як добираються хибні склади (дистрактори).
enum SlotAssemblyDistractorMode {
  /// Випадкові склади з пулу `syllableAudio`, відфільтрованого маскою
  /// дистракторів (за замовчуванням — маска складу з фільтра).
  pool,

  /// Для кожного правильного складу беруться найбільш схожі склади з пулу
  /// (найменша редакційна відстань): «ра» → «ро», «ре», «ба».
  /// Маска дистракторів застосовується лише якщо задана явно.
  similarToCorrect,
}

/// Генератор завдань SlotAssembly зі слів банку.
///
/// Мови. [language] це мова слова, яке складають зі складів (М1): за нею
/// працюють фільтр, склади, їх озвучка й дистрактори. Ціль (слово чи аудіо)
/// може бути іншою мовою (М2): [targetLanguage] для слова в цілі,
/// [targetAudioLanguage] для аудіо в цілі. Потрібні мови додаються у фільтр
/// автоматично, слова без перекладу відсіюються.
///
/// Приклад «бачимо турецьке слово й чуємо його, складаємо українське»:
/// ```dart
/// SlotAssemblyTaskDataGenerator(
///   bank: bank,
///   taskCount: 3,
///   wrongAnswerCount: 3,
///   language: Language.uk,
///   targetLanguage: Language.tr,
///   targetType: SlotAssemblyTargetType.wordWithAudio,
///   syllableAudio: syllableAudioUk,
/// )
/// ```
class SlotAssemblyTaskDataGenerator extends TaskDataGenerator {
  SlotAssemblyTaskDataGenerator({
    required this.bank,
    required this.taskCount,
    required this.wrongAnswerCount,
    required this.targetType,
    this.filter = const WordFilter(),
    this.language = Language.uk,
    this.targetLanguage,
    this.targetAudioLanguage,
    this.distractorPattern,
    this.distractorMode = SlotAssemblyDistractorMode.pool,
    this.targetEffect,
    this.targetFontSize,
    this.promptContent = const [TextContent('Склади слово')],
    this.textCase = MatchingTextCase.unchanged,
    Map<String, String> syllableAudio = const {},
    this.syllableHasSound = true,
    this.requireSyllableAudio = true,
    this.uiConfig = const SlotAssemblyUiConfig(),
    this.requiresSequentialSelection = true,
    this.interactionMode = const PressForSlotInteractionMode(),
    this.printDiagnostics = true,
    Random? random,
  }) : syllableAudio = Map.unmodifiable({
         for (final entry in syllableAudio.entries)
           normalizeWordKey(entry.key): entry.value,
       }),
       _random = random ?? Random();

  final WordBank bank;
  final Random _random;

  final int taskCount;
  final int wrongAnswerCount;

  /// Фільтр слів (маска складу, позиція, теги, довжини тощо).
  final WordFilter filter;

  final SlotAssemblyTargetType targetType;

  /// Мова слова, яке складають (М1).
  final Language language;

  /// Мова слова в цілі (типи word і wordWithAudio). null — основна.
  final Language? targetLanguage;

  /// Мова аудіо в цілі (типи imageWithAudio, wordWithAudio, audio).
  /// null — [targetLanguage], а якщо й вона не задана, основна.
  final Language? targetAudioLanguage;

  /// Маска складів-дистракторів. Якщо null:
  /// - режим [SlotAssemblyDistractorMode.pool] використовує маску складу
  ///   з [filter] (або всі склади, якщо її теж немає);
  /// - режим [SlotAssemblyDistractorMode.similarToCorrect] не обмежує пул.
  final String? distractorPattern;
  final SlotAssemblyDistractorMode distractorMode;

  /// Ефект цілі (saturation — для зображень, glow — для тексту).
  /// null — без ефекту. Кількість кроків за замовчуванням
  /// дорівнює кількості складів слова.
  final TargetEffectConfig? targetEffect;

  /// Розмір шрифта цілі, якщо вона текстова. null — стандартний.
  final double? targetFontSize;
  final MatchingTextCase textCase;

  /// Контент умови завдання (текст, аудіо тощо). Ціль (target)
  /// сюди не входить: вона визначається [targetType], [targetEffect]
  /// і [targetFontSize].
  final List<TaskContent> promptContent;

  /// Склад (нормалізований) → файл озвучки. Це також пул дистракторів.
  final Map<String, String> syllableAudio;
  final bool syllableHasSound;

  /// Якщо true і [syllableHasSound] увімкнено, слова, у яких хоча б
  /// один склад не має озвучки, пропускаються.
  final bool requireSyllableAudio;

  final SlotAssemblyUiConfig uiConfig;
  final bool requiresSequentialSelection;
  final SlotAssemblyInteractionMode interactionMode;

  /// Друкувати воронку відбору в консоль (лише в debug).
  final bool printDiagnostics;

  Language get _targetLang => targetLanguage ?? language;
  Language get _targetAudioLang => targetAudioLanguage ?? _targetLang;

  /// Чи показує ціль слово.
  bool get _targetShowsWord =>
      targetType == SlotAssemblyTargetType.word ||
      targetType == SlotAssemblyTargetType.wordWithAudio;

  /// Чи має ціль аудіо.
  bool get _targetHasAudio =>
      targetType == SlotAssemblyTargetType.imageWithAudio ||
      targetType == SlotAssemblyTargetType.wordWithAudio ||
      targetType == SlotAssemblyTargetType.audio;

  /// Слово потрібною мовою: основну беремо з відбору, іншу з запису.
  WordEntry? _entryFor(WordMatch match, Language lang) =>
      lang == language ? match.entry : match.record.entry(lang);

  @override
  List<TaskData> generate() {
    if (taskCount < 1) {
      throw ArgumentError.value(taskCount, 'taskCount', 'Must be at least 1.');
    }

    if (wrongAnswerCount < 0) {
      throw ArgumentError.value(
        wrongAnswerCount,
        'wrongAnswerCount',
        'Must not be negative.',
      );
    }

    final selection = _select();
    final matches = [...selection.funnel.matches];

    if (kDebugMode && printDiagnostics) {
      final rules = selection.funnel.rulesReport;
      debugPrint(
        'SlotAssembly [${targetType.name}]: ${selection.funnel.funnel} '
        '(потрібно: $taskCount)'
        '${rules.isEmpty ? '' : '\n$rules'}',
      );
    }

    if (matches.length < taskCount) {
      throw StateError(
        'Not enough suitable words to generate SlotAssemblyTaskData. '
        'Requested: $taskCount, available: ${matches.length}. '
        'Funnel: ${selection.funnel.funnel}.',
      );
    }

    matches.shuffle(_random);

    return List<SlotAssemblyTaskData<TaskContent>>.generate(taskCount, (index) {
      final match = matches[index];
      final syllables = match.entry.syllables;

      // Усі склади вибраного слова є правильними відповідями.
      final correctAnswers = syllables.map(_createSyllableContent).toList();

      final wrongAnswers = _pickDistractors(
        syllables,
        selection.pool,
      ).map(_createSyllableContent).toList();

      return SlotAssemblyTaskData<TaskContent>(
        prompt: TaskPrompt(
          content: promptContent,
          target: TargetContent(
            target: selection.targets[match.record.id]!,
            effect: targetEffect,
            fontSize: targetFontSize,
          ),
        ),
        correctAnswers: List.unmodifiable(correctAnswers),
        wrongAnswers: List.unmodifiable(wrongAnswers),
        wrongAnswerCount: wrongAnswerCount,
        uiConfig: uiConfig,
        requiresSequentialSelection: requiresSequentialSelection,
        interactionMode: interactionMode,
      );
    });
  }

  /// Воронка відбору без генерації завдань і без винятків:
  /// показує, скільки слів лишається після кожного етапу.
  WordFilterResult diagnose() => _select().funnel;

  // ---------------------------------------------------------------------
  // Відбір слів
  // ---------------------------------------------------------------------

  _Selection _select() {
    final targets = <String, TaskContent>{};
    final usedWordKeys = <String>{};
    final pool = _createDistractorPool();

    final needsSyllableAudio = syllableHasSound && requireSyllableAudio;
    var effectiveFilter = needsSyllableAudio
        ? filter.copyWith(requireSyllableAudio: SyllableAudioRequirement.all)
        : filter;

    // Слова без потрібного перекладу відсіюються.
    final extraLanguages = <Language>{
      if (_targetShowsWord) _targetLang,
      if (_targetHasAudio) _targetAudioLang,
    }..remove(language);

    if (extraLanguages.isNotEmpty) {
      effectiveFilter = effectiveFilter.copyWith(
        requiredLanguages: {
          ...effectiveFilter.requiredLanguages,
          ...extraLanguages,
        },
      );
    }

    var funnel = effectiveFilter.apply(
      bank,
      language,
      syllableAudio: syllableAudio,
    );

    // Слово має складатися з непорожніх складів.
    funnel = funnel.refine(
      'склади',
      (m) =>
          m.entry.syllables.isNotEmpty &&
          m.entry.syllables.every((s) => s.trim().isNotEmpty),
    );

    // Потрібні ресурси для цілі (картинка, аудіо слова).
    funnel = funnel.refine('ресурси цілі', (m) {
      final target = _createTargetContent(m);
      if (target == null) return false;

      targets[m.record.id] = target;
      return true;
    });

    // Ціль не має збігатися зі словом, яке складають (наприклад, однакове
    // слово в двох мовах: radar / radar). Для однієї мови збіг очікуваний.
    if (_targetShowsWord && _targetLang != language) {
      funnel = funnel.refine('збіг цілі зі словом', (m) {
        final target = _entryFor(m, _targetLang)?.word ?? '';
        return normalizeWordKey(target) != normalizeWordKey(m.entry.word);
      });
    }

    // Достатньо унікальних дистракторів, не рахуючи правильних складів.
    funnel = funnel.refine('дистрактори', (m) {
      final correctKeys = m.entry.syllables.map(normalizeWordKey).toSet();
      final overlap = correctKeys.where(pool.containsKey).length;
      return pool.length - overlap >= wrongAnswerCount;
    });

    // Однакові слова (омоніми різних концептів) не повторюються.
    funnel = funnel.refine('унікальність слова', (m) {
      final key = normalizeWordKey(m.entry.word);
      return key.isNotEmpty && usedWordKeys.add(key);
    });

    return _Selection(funnel: funnel, targets: targets, pool: pool);
  }

  // ---------------------------------------------------------------------
  // Дистрактори
  // ---------------------------------------------------------------------

  String? get _effectiveDistractorPattern {
    if (distractorPattern != null) return distractorPattern;

    return switch (distractorMode) {
      SlotAssemblyDistractorMode.pool => filter.syllablePattern,
      SlotAssemblyDistractorMode.similarToCorrect => null,
    };
  }

  /// Пул дистракторів: нормалізований склад → склад з озвучкою.
  Map<String, String> _createDistractorPool() {
    final pattern = _effectiveDistractorPattern;

    if (pattern != null && pattern.trim().isEmpty) {
      throw ArgumentError.value(
        pattern,
        'distractorPattern',
        'Must not be empty.',
      );
    }

    final result = <String, String>{};

    for (final entry in syllableAudio.entries) {
      final syllable = entry.key.trim();
      final audioPath = entry.value.trim();

      if (syllable.isEmpty || audioPath.isEmpty) continue;

      if (pattern != null && !WildcardPattern.matches(syllable, pattern)) {
        continue;
      }

      result.putIfAbsent(normalizeWordKey(syllable), () => syllable);
    }

    return result;
  }

  /// Вибирає рівно [wrongAnswerCount] унікальних хибних складів.
  List<String> _pickDistractors(
    List<String> correctSyllables,
    Map<String, String> pool,
  ) {
    if (wrongAnswerCount == 0) return const [];

    final correctKeys = correctSyllables.map(normalizeWordKey).toSet();

    final available = [
      for (final entry in pool.entries)
        if (!correctKeys.contains(entry.key)) entry,
    ];

    switch (distractorMode) {
      case SlotAssemblyDistractorMode.pool:
        available.shuffle(_random);
        return available.take(wrongAnswerCount).map((e) => e.value).toList();

      case SlotAssemblyDistractorMode.similarToCorrect:
        return _pickSimilarDistractors(correctKeys.toList(), available);
    }
  }

  /// Для кожного правильного складу складає рейтинг схожості, потім по колу
  /// бере по одному найближчому складу, поки не набере потрібну кількість.
  List<String> _pickSimilarDistractors(
    List<String> correctKeys,
    List<MapEntry<String, String>> available,
  ) {
    final rankings = [
      for (final correct in correctKeys)
        ([
          for (final candidate in available)
            (
              candidate: candidate,
              distance: _editDistance(correct, candidate.key),
              tie: _random.nextInt(1 << 30),
            ),
        ]..sort((a, b) {
          final byDistance = a.distance.compareTo(b.distance);
          return byDistance != 0 ? byDistance : a.tie.compareTo(b.tie);
        })),
    ];

    final cursors = List<int>.filled(rankings.length, 0);
    final chosenKeys = <String>{};
    final result = <String>[];

    while (result.length < wrongAnswerCount) {
      var progressed = false;

      for (var i = 0; i < rankings.length; i++) {
        if (result.length >= wrongAnswerCount) break;

        final ranking = rankings[i];

        while (cursors[i] < ranking.length &&
            chosenKeys.contains(ranking[cursors[i]].candidate.key)) {
          cursors[i]++;
        }

        if (cursors[i] >= ranking.length) continue;

        final pick = ranking[cursors[i]++].candidate;
        chosenKeys.add(pick.key);
        result.add(pick.value);
        progressed = true;
      }

      if (!progressed) break;
    }

    result.shuffle(_random);
    return result;
  }

  /// Редакційна відстань Левенштейна між двома рядками.
  static int _editDistance(String a, String b) {
    final x = a.runes.toList();
    final y = b.runes.toList();

    var previous = List<int>.generate(y.length + 1, (i) => i);

    for (var i = 1; i <= x.length; i++) {
      final current = List<int>.filled(y.length + 1, 0);
      current[0] = i;

      for (var j = 1; j <= y.length; j++) {
        final cost = x[i - 1] == y[j - 1] ? 0 : 1;
        current[j] = min(
          min(current[j - 1] + 1, previous[j] + 1),
          previous[j - 1] + cost,
        );
      }

      previous = current;
    }

    return previous[y.length];
  }

  // ---------------------------------------------------------------------
  // Контент
  // ---------------------------------------------------------------------

  TaskContent? _createTargetContent(WordMatch match) {
    final requiresWordAudio =
        targetType == SlotAssemblyTargetType.imageWithAudio ||
        targetType == SlotAssemblyTargetType.wordWithAudio ||
        targetType == SlotAssemblyTargetType.audio;

    AudioContent? audio;

    if (requiresWordAudio) {
      final audioPath = _entryFor(match, _targetAudioLang)?.audio?.trim();

      if (audioPath == null || audioPath.isEmpty) {
        return null;
      }

      audio = AudioContent.fixed(AudioPaths.resolvePronunciation(audioPath));
    }

    switch (targetType) {
      case SlotAssemblyTargetType.image:
      case SlotAssemblyTargetType.imageWithAudio:
        // Зображення, а за його відсутності — емодзі.
        return createPictureContent(
          match.concept,
          audio: audio,
          source: filter.pictureSource,
        );

      case SlotAssemblyTargetType.word:
      case SlotAssemblyTargetType.wordWithAudio:
        final targetEntry = _entryFor(match, _targetLang);

        if (targetEntry == null) {
          return null;
        }

        return TextContent(
          textCase.format(targetEntry.word, _targetLang),
          audio: audio,
        );

      case SlotAssemblyTargetType.audio:
        return audio;
    }
  }

  TaskContent _createSyllableContent(String syllable) {
    final formattedSyllable = textCase.format(syllable, language);

    if (!syllableHasSound) {
      return TextContent(formattedSyllable);
    }

    final audioPath = syllableAudio[normalizeWordKey(syllable)]?.trim();

    if (audioPath == null || audioPath.isEmpty) {
      return TextContent(formattedSyllable);
    }

    return TextContent(
      formattedSyllable,
      audio: AudioContent.fixed(AudioPaths.resolvePronunciation(audioPath)),
    );
  }
}

/// Результат відбору: слова з воронкою, цілі та пул дистракторів.
class _Selection {
  const _Selection({
    required this.funnel,
    required this.targets,
    required this.pool,
  });

  final WordFilterResult funnel;

  /// id концепту → контент цілі.
  final Map<String, TaskContent> targets;

  /// Нормалізований склад → склад з озвучкою.
  final Map<String, String> pool;
}
