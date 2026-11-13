import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/matching_column_element.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/matching_text_case.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/word_picture.dart';
import 'package:school_tasks/features/learning/data/generation/task_data_generator.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_button_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/math_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/word_content/audio_paths.dart';
import 'package:school_tasks/features/learning/domain/word_content/language.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_bank.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_filter.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_text.dart';

class SyllableMatchingTaskDataGenerator extends TaskDataGenerator {
  SyllableMatchingTaskDataGenerator({
    required this.bank,
    required this.taskCount,
    required this.pairCount,
    this.filter = const WordFilter(),
    this.language = Language.uk,
    this.buttonConfig,
    this.prompt = const TaskPrompt(content: [TextContent('Зістав елементи')]),
    this.leftColumnElement = MatchingColumnElement.image,
    this.rightColumnElement = MatchingColumnElement.syllable,
    this.leftColumnAudio = MatchingColumnAudio.none,
    this.rightColumnAudio = MatchingColumnAudio.none,
    this.swapColumns = false,
    this.textCase = MatchingTextCase.unchanged,
    Map<String, String> syllableAudio = const {},
    this.printDiagnostics = true,
    Random? random,
  }) : syllableAudio = Map.unmodifiable({
         for (final entry in syllableAudio.entries)
           normalizeWordKey(entry.key): entry.value,
       }),
       _random = random ?? Random() {
    _validateColumnConfiguration(
      leftColumnElement,
      leftColumnAudio,
      'leftColumn',
    );
    _validateColumnConfiguration(
      rightColumnElement,
      rightColumnAudio,
      'rightColumn',
    );
  }

  final WordBank bank;
  final Random _random;

  final int taskCount;
  final int pairCount;

  /// Фільтр слів (маска складу, позиція, теги, довжини тощо).
  final WordFilter filter;

  final Language language;
  final MatchingButtonConfig? buttonConfig;
  final TaskPrompt prompt;

  final MatchingColumnElement leftColumnElement;
  final MatchingColumnElement rightColumnElement;

  final MatchingColumnAudio leftColumnAudio;
  final MatchingColumnAudio rightColumnAudio;

  final bool swapColumns;
  final MatchingTextCase textCase;

  /// Склад (нормалізований) → файл озвучки.
  final Map<String, String> syllableAudio;

  /// Друкувати воронку відбору в консоль (лише в debug).
  final bool printDiagnostics;

  static void _validateColumnConfiguration(
    MatchingColumnElement element,
    MatchingColumnAudio audio,
    String columnName,
  ) {
    if (element == MatchingColumnElement.none &&
        audio == MatchingColumnAudio.none) {
      throw ArgumentError('$columnName must have a visible element or audio.');
    }
  }

  @override
  List<TaskData> generate() {
    if (taskCount < 1) {
      throw ArgumentError.value(taskCount, 'taskCount', 'Must be at least 1.');
    }

    if (pairCount < 1) {
      throw ArgumentError.value(pairCount, 'pairCount', 'Must be at least 1.');
    }

    final selection = _select();
    final pairs = selection.pairs;

    if (kDebugMode && printDiagnostics) {
      final rules = selection.funnel.rulesReport;
      debugPrint(
        'SyllableMatching: ${selection.funnel.funnel} '
        '(потрібно пар: $pairCount)'
        '${rules.isEmpty ? '' : '\n$rules'}',
      );
    }

    if (pairs.isEmpty) {
      throw StateError(
        'No matching pairs found for the selected configuration. '
        'Funnel: ${selection.funnel.funnel}.',
      );
    }

    if (pairCount > pairs.length) {
      throw StateError(
        'Requested $pairCount pairs, but only ${pairs.length} '
        'eligible pairs are available. '
        'Funnel: ${selection.funnel.funnel}.',
      );
    }

    return List<MatchingTaskData>.generate(
      taskCount,
      (_) => MatchingTaskData(
        prompt: prompt,
        pairs: List.unmodifiable(pairs),
        pairCount: pairCount,
        buttonConfig: buttonConfig,
      ),
    );
  }

  /// Воронка відбору без генерації завдань і без винятків:
  /// показує, скільки слів лишається після кожного етапу.
  WordFilterResult diagnose() => _select().funnel;

  // ---------------------------------------------------------------------
  // Відбір слів і побудова пар
  // ---------------------------------------------------------------------

  _Selection _select() {
    final pairsByConceptId = <String, MatchingPair>{};

    final needsImage =
        leftColumnElement == MatchingColumnElement.image ||
        rightColumnElement == MatchingColumnElement.image;

    // Якщо озвучка потрібна для складу, обираємо лише серед складів,
    // які її мають.
    final needsSyllableAudio =
        leftColumnAudio == MatchingColumnAudio.syllable ||
        rightColumnAudio == MatchingColumnAudio.syllable;

    final effectiveFilter =
        needsSyllableAudio &&
            filter.requireSyllableAudio == SyllableAudioRequirement.none
        ? filter.copyWith(
            requireSyllableAudio: SyllableAudioRequirement.matching,
          )
        : filter;

    var funnel = effectiveFilter.apply(
      bank,
      language,
      syllableAudio: syllableAudio,
    );

    // Зображення є обов'язковим лише для конфігурацій, які його показують.
    if (needsImage) {
      funnel = funnel.refine('зображення', (m) => m.concept.hasPicture);
    }

    // Потрібен хоча б один непорожній склад.
    funnel = funnel.transform('склади', (m) {
      final syllables = m.syllables.where((s) => s.trim().isNotEmpty).toList();
      return syllables.isEmpty ? null : m.withSyllables(syllables);
    });

    // Якщо для обраної конфігурації бракує потрібного аудіо
    // або іншого ресурсу, цей запис не використовується.
    funnel = funnel.refine('ресурси пар', (m) {
      final syllable = m.syllables[_random.nextInt(m.syllables.length)];

      final leftContent = _createColumnContent(
        match: m,
        syllable: syllable,
        element: leftColumnElement,
        audio: leftColumnAudio,
      );

      final rightContent = _createColumnContent(
        match: m,
        syllable: syllable,
        element: rightColumnElement,
        audio: rightColumnAudio,
      );

      if (leftContent == null || rightContent == null) return false;

      pairsByConceptId[m.record.id] = MatchingPair(
        left: swapColumns ? rightContent : leftContent,
        right: swapColumns ? leftContent : rightContent,
      );
      return true;
    });

    return _Selection(
      funnel: funnel,
      pairs: [for (final m in funnel.matches) pairsByConceptId[m.record.id]!],
    );
  }

  // ---------------------------------------------------------------------
  // Контент
  // ---------------------------------------------------------------------

  TaskContent? _createColumnContent({
    required WordMatch match,
    required String syllable,
    required MatchingColumnElement element,
    required MatchingColumnAudio audio,
  }) {
    TaskContent? visibleContent;

    switch (element) {
      case MatchingColumnElement.none:
        visibleContent = null;
        break;

      case MatchingColumnElement.image:
        // Зображення, а за його відсутності — емодзі.
        visibleContent = createPictureContent(match.concept);
        if (visibleContent == null) {
          return null;
        }
        break;

      case MatchingColumnElement.word:
        visibleContent = TextContent(textCase.format(match.entry.word));
        break;

      case MatchingColumnElement.syllable:
        visibleContent = TextContent(textCase.format(syllable));
        break;
    }

    if (audio == MatchingColumnAudio.none) {
      return visibleContent;
    }

    final String? audioFile;

    switch (audio) {
      case MatchingColumnAudio.none:
        audioFile = null;
        break;

      case MatchingColumnAudio.word:
        audioFile = match.entry.audio;
        break;

      case MatchingColumnAudio.syllable:
        audioFile = syllableAudio[normalizeWordKey(syllable)];
        break;
    }

    final normalizedAudio = audioFile?.trim();

    // Якщо аудіо задане конфігурацією, воно має бути доступним.
    if (normalizedAudio == null || normalizedAudio.isEmpty) {
      return null;
    }

    final audioContent = AudioContent.fixed(
      AudioPaths.resolvePronunciation(normalizedAudio),
    );

    // Аудіо без тексту/зображення стає самостійним елементом.
    if (visibleContent == null) {
      return audioContent;
    }

    return _withAudio(visibleContent, audioContent);
  }

  TaskContent _withAudio(TaskContent content, AudioContent audio) {
    return switch (content) {
      TextContent(:final text) => TextContent(text, audio: audio),
      ImageContent(:final imagePath) => ImageContent(imagePath, audio: audio),
      EmojiContent(:final emoji) => EmojiContent(emoji, audio: audio),
      MathContent(:final expression) => MathContent(expression, audio: audio),
      _ => throw ArgumentError(
        'Контент ${content.runtimeType} не підтримує аудіо',
      ),
    };
  }
}

/// Результат відбору: воронка та готові пари.
class _Selection {
  const _Selection({required this.funnel, required this.pairs});

  final WordFilterResult funnel;
  final List<MatchingPair> pairs;
}
