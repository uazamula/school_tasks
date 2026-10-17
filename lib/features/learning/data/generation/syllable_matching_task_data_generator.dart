import 'dart:math';

import 'package:school_tasks/features/learning/data/generation/task_data_generator.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_button_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_linked_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/word_content/language.dart';
import 'package:school_tasks/features/learning/domain/word_content/syllable_search_position.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_concept.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_entry.dart';

/// Generates matching tasks where learners match a word's image to a syllable.
///
/// A word is included if at least one eligible syllable matches
/// [syllablePattern]. If several syllables match, one is selected randomly.
///
/// Different words may produce pairs with the same syllable.

const String _pronunciationAudioDirectory = 'assets/audio/pronunciation/';

String _resolveAudioPath(String audio) {
  final value = audio.trim();

  if (value.startsWith('assets/')) {
    return value;
  }

  return '$_pronunciationAudioDirectory$value';
}

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
    this.prompt = const TaskPrompt(
      content: [TextContent('Зістав зображення зі складом')],
    ),
    this.includeWordAudio = false,
    this.includeSyllableAudio = false,
    Map<String, String> syllableAudio = const {},
    Random? random,
  }) : _words = List.unmodifiable(words),
       _concepts = List.unmodifiable(concepts),
       syllableAudio = Map.unmodifiable(syllableAudio),
       _random = random ?? Random();

  final List<WordEntry> _words;
  final List<WordConcept> _concepts;
  final Random _random;

  final bool includeWordAudio;
  final bool includeSyllableAudio;
  final Map<String, String> syllableAudio;

  /// Number of matching tasks to generate.
  final int taskCount;

  /// Number of pairs available in one displayed task.
  final int pairCount;

  /// Wildcard pattern, for example `р*`, `р?`, `*р`, or `*ря*`.
  ///
  /// `*` matches zero or more characters.
  /// `?` matches exactly one character.
  final String syllablePattern;

  final Language language;
  final SyllableSearchPosition position;
  final MatchingButtonConfig? buttonConfig;
  final TaskPrompt prompt;

  @override
  List<TaskData> generate() {
    if (taskCount < 1) {
      throw ArgumentError.value(
        taskCount,
        'taskCount',
        'Must be greater than zero.',
      );
    }

    if (pairCount < 1) {
      throw ArgumentError.value(
        pairCount,
        'pairCount',
        'Must be greater than zero.',
      );
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

    final pairs = <MatchingPair>[];
    final usedConceptIds = <String>{};

    for (final word in _words) {
      if (word.language != language) continue;

      final conceptId = word.conceptId;
      if (conceptId == null || usedConceptIds.contains(conceptId)) {
        continue;
      }

      final concept = conceptsById[conceptId];
      if (concept == null) continue;

      final imagePath = concept.image;
      if (imagePath == null || imagePath.trim().isEmpty) continue;

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

      TaskContent imageContent = ImageContent(imagePath);

      final wordAudio = word.audio?.trim();

      if (includeWordAudio && wordAudio != null && wordAudio.isNotEmpty) {
        imageContent = AudioLinkedContent(
          content: imageContent,
          audio: AudioContent.fixed(_resolveAudioPath(wordAudio)),
        );
      }

      TaskContent syllableContent = TextContent(selectedSyllable);

      if (includeSyllableAudio) {
        final audioFile = syllableAudio[selectedSyllable.trim().toLowerCase()];

        if (audioFile != null && audioFile.trim().isNotEmpty) {
          syllableContent = AudioLinkedContent(
            content: syllableContent,
            audio: AudioContent.fixed(_resolveAudioPath(audioFile)),
          );
        }
      }

      pairs.add(MatchingPair(left: imageContent, right: syllableContent));

      usedConceptIds.add(conceptId);
    }

    if (pairs.isEmpty) {
      throw StateError(
        'No matching image-syllable pairs found for '
        'language $language and pattern "$syllablePattern".',
      );
    }

    if (pairCount > pairs.length) {
      throw StateError(
        'Requested $pairCount pairs, but only '
        '${pairs.length} unique matching pairs are available '
        'for pattern "$syllablePattern".',
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
}
