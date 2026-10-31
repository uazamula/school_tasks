import 'dart:math';

import 'package:school_tasks/features/learning/data/generation/linguistic/matching_column_element.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/matching_text_case.dart';
import 'package:school_tasks/features/learning/data/generation/task_data_generator.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_button_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/math_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/word_content/language.dart';
import 'package:school_tasks/features/learning/domain/word_content/syllable_search_position.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_concept.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_entry.dart';

class SyllableMatchingTaskDataGenerator extends TaskDataGenerator {
  SyllableMatchingTaskDataGenerator({
    required List<WordEntry> words,
    required List<WordConcept> concepts,
    required this.taskCount,
    required this.pairCount,
    required this.syllablePattern,
    this.language = Language.uk,
    this.position = SyllableSearchPosition.any,
    this.buttonConfig,
    this.prompt = const TaskPrompt(content: [TextContent('Зістав елементи')]),
    this.leftColumnElement = MatchingColumnElement.image,
    this.rightColumnElement = MatchingColumnElement.syllable,
    this.leftColumnAudio = MatchingColumnAudio.none,
    this.rightColumnAudio = MatchingColumnAudio.none,
    this.swapColumns = false,
    this.textCase = MatchingTextCase.unchanged,
    Map<String, String> syllableAudio = const {},
    Random? random,
  }) : _words = List.unmodifiable(words),
       _concepts = List.unmodifiable(concepts),
       syllableAudio = Map.unmodifiable(syllableAudio),
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

  final List<WordEntry> _words;
  final List<WordConcept> _concepts;
  final Random _random;

  final int taskCount;
  final int pairCount;
  final String syllablePattern;

  final Language language;
  final SyllableSearchPosition position;
  final MatchingButtonConfig? buttonConfig;
  final TaskPrompt prompt;

  final MatchingColumnElement leftColumnElement;
  final MatchingColumnElement rightColumnElement;

  final MatchingColumnAudio leftColumnAudio;
  final MatchingColumnAudio rightColumnAudio;

  final bool swapColumns;
  final MatchingTextCase textCase;

  final Map<String, String> syllableAudio;

  static const String _pronunciationAudioDirectory =
      'assets/audio/pronunciation/';

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

  String _resolveAudioPath(String audio) {
    final value = audio.trim();

    if (value.startsWith('assets/')) {
      return value;
    }

    return '$_pronunciationAudioDirectory$value';
  }

  @override
  List<TaskData> generate() {
    if (taskCount < 1) {
      throw ArgumentError.value(taskCount, 'taskCount', 'Must be at least 1.');
    }

    if (pairCount < 1) {
      throw ArgumentError.value(pairCount, 'pairCount', 'Must be at least 1.');
    }

    if (syllablePattern.trim().isEmpty) {
      throw ArgumentError.value(
        syllablePattern,
        'syllablePattern',
        'Must not be empty.',
      );
    }

    final conceptsById = <String, WordConcept>{
      for (final concept in _concepts) concept.id: concept,
    };

    final needsImage =
        leftColumnElement == MatchingColumnElement.image ||
        rightColumnElement == MatchingColumnElement.image;

    final pairs = <MatchingPair>[];
    final usedConceptIds = <String>{};

    for (final word in _words) {
      if (word.language != language) continue;

      final conceptId = word.conceptId;
      if (conceptId == null || usedConceptIds.contains(conceptId)) {
        continue;
      }

      // Зберігаємо попередню політику: потрібен наявний концепт.
      final concept = conceptsById[conceptId];
      if (concept == null) continue;

      // Зображення є обов'язковим лише для конфігурацій, які його показують.
      if (needsImage) {
        final imagePath = concept.image;
        if (imagePath == null || imagePath.trim().isEmpty) {
          continue;
        }
      }

      if (word.syllables.isEmpty) continue;

      final eligibleSyllables = switch (position) {
        SyllableSearchPosition.any => word.syllables,
        SyllableSearchPosition.first => word.syllables.take(1).toList(),
      };

      final matchingSyllables = eligibleSyllables
          .where(
            (syllable) =>
                syllable.trim().isNotEmpty &&
                _matchesPattern(syllable, syllablePattern),
          )
          .toList();

      if (matchingSyllables.isEmpty) continue;

      final selectedSyllable =
          matchingSyllables[_random.nextInt(matchingSyllables.length)];

      final leftContent = _createColumnContent(
        word: word,
        concept: concept,
        syllable: selectedSyllable,
        element: leftColumnElement,
        audio: leftColumnAudio,
      );

      final rightContent = _createColumnContent(
        word: word,
        concept: concept,
        syllable: selectedSyllable,
        element: rightColumnElement,
        audio: rightColumnAudio,
      );

      // Якщо для обраної конфігурації бракує потрібного аудіо
      // або іншого ресурсу, цей запис не використовується.
      if (leftContent == null || rightContent == null) {
        continue;
      }

      pairs.add(
        MatchingPair(
          left: swapColumns ? rightContent : leftContent,
          right: swapColumns ? leftContent : rightContent,
        ),
      );

      usedConceptIds.add(conceptId);
    }

    if (pairs.isEmpty) {
      throw StateError(
        'No matching pairs found for the selected configuration '
        'and syllable pattern "$syllablePattern".',
      );
    }

    if (pairCount > pairs.length) {
      throw StateError(
        'Requested $pairCount pairs, but only ${pairs.length} '
        'eligible pairs are available.',
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

  TaskContent? _createColumnContent({
    required WordEntry word,
    required WordConcept concept,
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
        final imagePath = concept.image?.trim();
        if (imagePath == null || imagePath.isEmpty) {
          return null;
        }
        visibleContent = ImageContent(imagePath);
        break;

      case MatchingColumnElement.word:
        visibleContent = TextContent(_formatText(word.word));
        break;

      case MatchingColumnElement.syllable:
        visibleContent = TextContent(_formatText(syllable));
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
        audioFile = word.audio;
        break;

      case MatchingColumnAudio.syllable:
        audioFile = syllableAudio[syllable.trim().toLowerCase()];
        break;
    }

    final normalizedAudio = audioFile?.trim();

    // Якщо аудіо задане конфігурацією, воно має бути доступним.
    if (normalizedAudio == null || normalizedAudio.isEmpty) {
      return null;
    }

    final audioContent = AudioContent.fixed(_resolveAudioPath(normalizedAudio));

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

  /// Matches a string against a wildcard pattern.
  ///
  /// Matching is case-insensitive.
  /// `*` matches any sequence, including an empty sequence.
  /// `?` matches exactly one Unicode code point.
  static bool _matchesPattern(String value, String pattern) {
    final text = value.trim().toLowerCase().runes.toList();
    final mask = pattern.trim().toLowerCase().runes.toList();

    var textIndex = 0;
    var maskIndex = 0;
    var lastStarIndex = -1;
    var retryTextIndex = 0;

    while (textIndex < text.length) {
      if (maskIndex < mask.length &&
          (mask[maskIndex] == 0x3F || mask[maskIndex] == text[textIndex])) {
        // '?' or an exact character.
        maskIndex++;
        textIndex++;
      } else if (maskIndex < mask.length && mask[maskIndex] == 0x2A) {
        // Remember '*' so it can absorb more characters if necessary.
        lastStarIndex = maskIndex;
        retryTextIndex = textIndex;
        maskIndex++;
      } else if (lastStarIndex != -1) {
        // Let the most recent '*' absorb one more character.
        maskIndex = lastStarIndex + 1;
        retryTextIndex++;
        textIndex = retryTextIndex;
      } else {
        return false;
      }
    }

    // Trailing '*' characters can match an empty sequence.
    while (maskIndex < mask.length && mask[maskIndex] == 0x2A) {
      maskIndex++;
    }

    return maskIndex == mask.length;
  }

  String _formatText(String text) {
    switch (textCase) {
      case MatchingTextCase.unchanged:
        return text;

      case MatchingTextCase.uppercase:
        return text.toUpperCase();

      case MatchingTextCase.lowercase:
        return text.toLowerCase();

      case MatchingTextCase.title:
        final value = text.toLowerCase();
        if (value.isEmpty) return value;

        return '${value[0].toUpperCase()}${value.substring(1)}';
    }
  }
}
