import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:school_tasks/features/learning/data/generation/hidden_word_grid_builder.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/matching_text_case.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/word_picture.dart';
import 'package:school_tasks/features/learning/data/generation/task_data_generator.dart';
import 'package:school_tasks/features/learning/domain/task_data/position_selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/content_grid.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/target_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/selection_mode.dart';
import 'package:school_tasks/features/learning/domain/word_content/alphabets.dart';
import 'package:school_tasks/features/learning/domain/word_content/audio_paths.dart';
import 'package:school_tasks/features/learning/domain/word_content/language.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_bank.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_direction.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_entry.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_filter.dart';

/// Що показувати в підказці до захованого слова.
enum HiddenWordHintElement { none, image, word }

/// Озвучка підказки.
enum HiddenWordHintAudio { none, word }

/// Генератор завдань «знайди заховане слово».
///
/// Слово береться з [language] і ховається в сітці [rows] × [columns].
/// Підказка (зображення, слово іншою мовою, озвучка) показується в умові.
/// Слова з літерами поза абеткою, задовгі й ті, що не вміщаються в сітку
/// в дозволених напрямках, відсіюються (див. воронку).
///
/// Приклад «картинка → знайди слово»:
/// ```dart
/// HiddenWordTaskDataGenerator(
///   bank: ukWordBank,
///   taskCount: 5,
///   rows: 5,
///   columns: 5,
///   filter: WordFilter(wordLength: IntRange(min:2, max:4)),
///   hintElement: HiddenWordHintElement.image,
///   hintAudio: HiddenWordHintAudio.word,
/// )
/// ```
///
/// Приклад «слово іншою мовою»:
/// `hintElement: HiddenWordHintElement.word, hintLanguage: Language.en`.
class HiddenWordTaskDataGenerator extends TaskDataGenerator {
  HiddenWordTaskDataGenerator({
    required this.bank,
    required this.taskCount,
    required this.rows,
    required this.columns,
    this.filter = const WordFilter(),
    this.language = Language.uk,
    this.directions = WordDirection.easy,
    this.hintElement = HiddenWordHintElement.image,
    this.hintAudio = HiddenWordHintAudio.none,
    this.hintLanguage,
    this.audioLanguage,
    this.hintTextCase = MatchingTextCase.unchanged,
    this.textCase = MatchingTextCase.uppercase,
    List<String>? fillerAlphabet,
    this.promptText = 'Знайди заховане слово',
    this.printDiagnostics = true,
    Random? random,
  }) : fillerAlphabet = fillerAlphabet == null
           ? null
           : List.unmodifiable(fillerAlphabet),
       _random = random ?? Random() {
    _validate();
  }

  final WordBank bank;
  final Random _random;

  final int taskCount;
  final int rows;
  final int columns;

  final WordFilter filter;

  /// Мова захованого слова.
  final Language language;

  /// Дозволені напрямки слова в сітці.
  final Set<WordDirection> directions;

  final HiddenWordHintElement hintElement;
  final HiddenWordHintAudio hintAudio;

  /// Мова слова-підказки. null — основна (але тоді слово-підказка
  /// збігалась би з відповіддю, тому для [HiddenWordHintElement.word]
  /// мову треба вказати й вона має відрізнятись від основної).
  final Language? hintLanguage;

  /// Мова озвучки. null — основна.
  final Language? audioLanguage;

  /// Регістр слова-підказки.
  final MatchingTextCase hintTextCase;

  /// Регістр літер у сітці.
  final MatchingTextCase textCase;

  /// Літери для заповнення (нижній регістр). null — вся абетка мови.
  final List<String>? fillerAlphabet;

  final String promptText;
  final bool printDiagnostics;

  Language get _hintLang => hintLanguage ?? language;

  Language get _audioLang => audioLanguage ?? language;

  // Апострофи, дефіс і пробіли з захованого слова прибираються.
  static final RegExp _ignoredChars = RegExp(r"[\s\-'’ʼ`]");

  void _validate() {
    if (taskCount < 1) {
      throw ArgumentError.value(taskCount, 'taskCount', 'Must be at least 1.');
    }

    if (rows < 1 || columns < 1) {
      throw ArgumentError('rows and columns must be at least 1.');
    }

    if (directions.isEmpty) {
      throw ArgumentError('directions must not be empty.');
    }

    if (hintElement == HiddenWordHintElement.none &&
        hintAudio == HiddenWordHintAudio.none) {
      throw ArgumentError('The hint must have a visible element or audio.');
    }

    if (hintElement == HiddenWordHintElement.word && _hintLang == language) {
      throw ArgumentError(
        'hintLanguage must differ from language, otherwise the hint '
        'shows the answer.',
      );
    }
  }

  @override
  List<TaskData> generate() {
    final selection = _select();
    final matches = selection.funnel.matches;

    if (kDebugMode && printDiagnostics) {
      final rules = selection.funnel.rulesReport;
      debugPrint(
        'HiddenWord: ${selection.funnel.funnel}'
        '${rules.isEmpty ? '' : '\n$rules'}',
      );
    }

    if (matches.isEmpty) {
      throw StateError(
        'No words found for the selected configuration. '
        'Funnel: ${selection.funnel.funnel}.',
      );
    }

    final builder = HiddenWordGridBuilder(
      rows: rows,
      columns: columns,
      alphabet: fillerAlphabet ?? Alphabets.of(language),
      directions: directions,
      random: _random,
    );

    // Слова беруться по колу з перемішуванням, щоб не повторювались,
    // доки не вичерпається список.
    final queue = <WordMatch>[];

    return List<PositionSelectionTaskData>.generate(taskCount, (_) {
      if (queue.isEmpty) {
        // matches незмінний, тому перемішуємо копію.
        queue.addAll([...matches]..shuffle(_random));
      }

      return _createTask(queue.removeLast(), selection, builder);
    });
  }

  /// Воронка відбору без генерації завдань і без винятків.
  WordFilterResult diagnose() => _select().funnel;

  PositionSelectionTaskData _createTask(
    WordMatch match,
    _Selection selection,
    HiddenWordGridBuilder builder,
  ) {
    final letters = selection.lettersById[match.record.id]!;
    final grid = builder.build(letters);

    if (grid == null) {
      throw StateError('Word "${match.record.id}" does not fit the grid.');
    }

    final hint = selection.hintsById[match.record.id]!;

    // Підказка без видимого елемента (лише озвучка) іде в умову як аудіо.
    final visible = hint.visible;

    return PositionSelectionTaskData(
      prompt: TaskPrompt(
        content: [TextContent(promptText), if (visible == null) hint.audio!],
        target: visible == null ? null : TargetContent(target: visible),
      ),
      grid: ContentGrid([
        for (final row in grid.cells)
          [
            for (final letter in row)
              TextContent(textCase.format(letter, language)),
          ],
      ]),
      correctPositions: grid.positions,
      selectionMode: SelectionMode.multiple,
      requiresConfirmation: true,
    );
  }

  // ---------------------------------------------------------------------
  // Відбір слів
  // ---------------------------------------------------------------------

  _Selection _select() {
    final lettersById = <String, List<String>>{};
    final hintsById = <String, _Hint>{};

    var effectiveFilter = filter;
    // Слова з літерами поза абеткою відсіює фільтр.
    effectiveFilter = effectiveFilter.copyWith(onlyAlphabetLetters: true);

    final extraLanguages = {
      if (hintElement == HiddenWordHintElement.word) _hintLang,
      if (hintAudio == HiddenWordHintAudio.word) _audioLang,
    }..remove(language);

    if (extraLanguages.isNotEmpty) {
      effectiveFilter = effectiveFilter.copyWith(
        requiredLanguages: {
          ...effectiveFilter.requiredLanguages,
          ...extraLanguages,
        },
      );
    }

    var funnel = effectiveFilter.apply(bank, language);

    if (hintElement == HiddenWordHintElement.image) {
      funnel = funnel.refine('зображення', (m) => m.concept.hasPicture);
    }

    // Фільтр уже гарантує літери абетки, тут лише розбір на літери.
    funnel = funnel.refine('розбір літер', (m) {
      final letters = Alphabets.lettersOf(m.entry.word, language);
      if (letters == null) return false;

      lettersById[m.record.id] = letters;
      return true;
    });

    funnel = funnel.refine(
      'розмір сітки',
      (m) => _fitsGrid(lettersById[m.record.id]!.length),
    );

    funnel = funnel.refine('ресурси підказки', (m) {
      final hint = _createHint(m, lettersById[m.record.id]!);
      if (hint == null) return false;

      hintsById[m.record.id] = hint;
      return true;
    });

    return _Selection(
      funnel: funnel,
      lettersById: lettersById,
      hintsById: hintsById,
    );
  }

  String textCaseLower(String word) =>
      MatchingTextCase.lowercase.format(word, language);

  /// Чи вміщається слово хоч в одному дозволеному напрямку.
  bool _fitsGrid(int length) {
    if (length < 2) return false;

    return directions.any(
      (d) =>
          (length - 1) * d.rowStep.abs() < rows &&
          (length - 1) * d.columnStep.abs() < columns,
    );
  }

  WordEntry? _entryFor(WordMatch match, Language lang) =>
      lang == language ? match.entry : match.record.entry(lang);

  _Hint? _createHint(WordMatch match, List<String> letters) {
    TaskContent? visible;

    switch (hintElement) {
      case HiddenWordHintElement.none:
        break;

      case HiddenWordHintElement.image:
        visible = createPictureContent(
          match.concept,
          source: filter.pictureSource,
        );
        if (visible == null) return null;

      case HiddenWordHintElement.word:
        final entry = _entryFor(match, _hintLang);
        if (entry == null) return null;

        // Однакове слово в двох мовах (radar / radar) видало б відповідь.
        final hintKey = textCaseLower(entry.word).replaceAll(_ignoredChars, '');
        if (hintKey == letters.join()) return null;

        visible = TextContent(hintTextCase.format(entry.word, _hintLang));
    }

    AudioContent? audio;

    if (hintAudio == HiddenWordHintAudio.word) {
      final file = _entryFor(match, _audioLang)?.audio?.trim();

      // Якщо озвучка задана конфігурацією, вона має бути доступною.
      if (file == null || file.isEmpty) return null;

      audio = AudioContent.fixed(AudioPaths.resolvePronunciation(file));
    }

    if (visible != null && audio != null) {
      visible = _withAudio(visible, audio);
      audio = null;
    }

    return _Hint(visible: visible, audio: audio);
  }

  TaskContent _withAudio(TaskContent content, AudioContent audio) {
    return switch (content) {
      TextContent(:final text) => TextContent(text, audio: audio),
      ImageContent(:final imagePath) => ImageContent(imagePath, audio: audio),
      EmojiContent(:final emoji) => EmojiContent(emoji, audio: audio),
      _ => throw ArgumentError(
        'Контент ${content.runtimeType} не підтримує аудіо',
      ),
    };
  }
}

/// Підказка: видимий елемент (з аудіо або без) або лише аудіо.
class _Hint {
  const _Hint({this.visible, this.audio});

  final TaskContent? visible;
  final AudioContent? audio;
}

class _Selection {
  const _Selection({
    required this.funnel,
    required this.lettersById,
    required this.hintsById,
  });

  final WordFilterResult funnel;
  final Map<String, List<String>> lettersById;
  final Map<String, _Hint> hintsById;
}
