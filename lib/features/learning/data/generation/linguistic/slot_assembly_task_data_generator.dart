import 'dart:math';

import 'package:school_tasks/features/learning/data/generation/linguistic/matching_text_case.dart';
import 'package:school_tasks/features/learning/data/generation/task_data_generator.dart';
import 'package:school_tasks/features/learning/domain/task_data/slot_assembly_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/slot_assembly_ui_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/target_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/slot_assembly_interaction_mode.dart';
import 'package:school_tasks/features/learning/domain/word_content/language.dart';
import 'package:school_tasks/features/learning/domain/word_content/syllable_search_position.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_concept.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_entry.dart';

enum SlotAssemblyTargetType {
  image,
  word,
  imageWithAudio,
  wordWithAudio,
  audio,
}

class SlotAssemblyTaskDataGenerator extends TaskDataGenerator {
  SlotAssemblyTaskDataGenerator({
    required List<WordEntry> words,
    required List<WordConcept> concepts,
    required this.taskCount,
    required this.wrongAnswerCount,
    required this.syllablePattern,
    required this.targetType,
    this.language = Language.uk,
    this.position = SyllableSearchPosition.any,

    this.targetEffect,
    this.targetFontSize,
    this.promptContent = const [TextContent('Склади слово')],

    this.textCase = MatchingTextCase.unchanged,
    Map<String, String> syllableAudio = const {},
    this.syllableHasSound = true,
    this.uiConfig = const SlotAssemblyUiConfig(),
    this.requiresSequentialSelection = true,
    this.interactionMode = const PressForSlotInteractionMode(),
    Random? random,
  }) : _words = List.unmodifiable(words),
       _concepts = List.unmodifiable(concepts),
       syllableAudio = Map.unmodifiable({
         for (final entry in syllableAudio.entries)
           entry.key.trim().toLowerCase(): entry.value,
       }),
       _random = random ?? Random();

  final List<WordEntry> _words;
  final List<WordConcept> _concepts;
  final Random _random;

  final int taskCount;
  final int wrongAnswerCount;
  final String syllablePattern;

  final SlotAssemblyTargetType targetType;
  final Language language;
  final SyllableSearchPosition position;

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

  final Map<String, String> syllableAudio;
  final bool syllableHasSound;

  final SlotAssemblyUiConfig uiConfig;
  final bool requiresSequentialSelection;
  final SlotAssemblyInteractionMode interactionMode;

  static const String _pronunciationAudioDirectory =
      'assets/audio/pronunciation/';

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

    if (syllablePattern.trim().isEmpty) {
      throw ArgumentError.value(
        syllablePattern,
        'syllablePattern',
        'Must not be empty.',
      );
    }

    final conceptsById = {for (final concept in _concepts) concept.id: concept};

    // Build the unique distractor syllable pool from audio resources.
    final distractorPool = _createDistractorPool();

    final suitableWords = <_SlotAssemblyCandidate>[];
    final usedWordKeys = <String>{};

    for (final word in _words) {
      if (word.language != language) continue;

      final wordKey = _normalize(word.word);

      if (wordKey.isEmpty || usedWordKeys.contains(wordKey)) {
        continue;
      }

      if (word.syllables.isEmpty ||
          word.syllables.any((syllable) => syllable.trim().isEmpty)) {
        continue;
      }

      // Check the target word against the requested position.
      final eligibleSyllables = switch (position) {
        SyllableSearchPosition.any => word.syllables,
        SyllableSearchPosition.first => word.syllables.take(1).toList(),
      };

      final hasMatchingSyllable = eligibleSyllables.any(
        (syllable) => _matchesPattern(syllable, syllablePattern),
      );

      if (!hasMatchingSyllable) continue;

      final conceptId = word.conceptId;
      final concept = conceptId == null ? null : conceptsById[conceptId];

      final target = _createTargetContent(word: word, concept: concept);

      if (target == null) continue;

      // All syllables of the selected word are correct answers.
      final correctAnswers = word.syllables
          .map(_createSyllableContent)
          .toList();

      // Exclude correct syllables from the distractor pool.
      final correctSyllableKeys = word.syllables.map(_normalize).toSet();

      final availableDistractors = distractorPool.entries
          .where((entry) => !correctSyllableKeys.contains(entry.key))
          .toList();

      // Skip this word if there aren't enough unique distractors.
      if (availableDistractors.length < wrongAnswerCount) {
        continue;
      }

      // Select exactly wrongAnswerCount random distractors.
      availableDistractors.shuffle(_random);

      final wrongAnswers = availableDistractors
          .take(wrongAnswerCount)
          .map((entry) => entry.value)
          .toList();

      suitableWords.add(
        _SlotAssemblyCandidate(
          target: target,
          correctAnswers: correctAnswers,
          wrongAnswers: wrongAnswers,
        ),
      );

      usedWordKeys.add(wordKey);
    }

    if (suitableWords.length < taskCount) {
      throw StateError(
        'Not enough suitable words to generate SlotAssemblyTaskData. '
        'Requested: $taskCount, available: ${suitableWords.length}. '
        'Check the target resources and available distractor syllables.',
      );
    }

    suitableWords.shuffle(_random);

    return List<SlotAssemblyTaskData<TaskContent>>.generate(taskCount, (index) {
      final candidate = suitableWords[index];

      return SlotAssemblyTaskData<TaskContent>(
        prompt: TaskPrompt(
          content: promptContent,
          target: TargetContent(
            target: candidate.target,
            effect: targetEffect,
            fontSize: targetFontSize,
          ),
        ),
        correctAnswers: List.unmodifiable(candidate.correctAnswers),
        wrongAnswers: List.unmodifiable(candidate.wrongAnswers),
        wrongAnswerCount: wrongAnswerCount,
        uiConfig: uiConfig,
        requiresSequentialSelection: requiresSequentialSelection,
        interactionMode: interactionMode,
      );
    });
  }

  Map<String, TaskContent> _createDistractorPool() {
    final result = <String, TaskContent>{};

    for (final entry in syllableAudio.entries) {
      final syllable = entry.key.trim();
      final audioPath = entry.value.trim();

      if (syllable.isEmpty || audioPath.isEmpty) continue;

      if (!_matchesPattern(syllable, syllablePattern)) {
        continue;
      }

      final key = _normalize(syllable);

      result.putIfAbsent(key, () => _createSyllableContent(syllable));
    }

    return result;
  }

  TaskContent? _createTargetContent({
    required WordEntry word,
    required WordConcept? concept,
  }) {
    final requiresWordAudio =
        targetType == SlotAssemblyTargetType.imageWithAudio ||
        targetType == SlotAssemblyTargetType.wordWithAudio ||
        targetType == SlotAssemblyTargetType.audio;

    AudioContent? audio;

    if (requiresWordAudio) {
      final audioPath = word.audio?.trim();

      if (audioPath == null || audioPath.isEmpty) {
        return null;
      }

      audio = AudioContent.fixed(_resolveAudioPath(audioPath));
    }

    switch (targetType) {
      case SlotAssemblyTargetType.image:
      case SlotAssemblyTargetType.imageWithAudio:
        final imagePath = concept?.image?.trim();

        if (imagePath == null || imagePath.isEmpty) {
          return null;
        }

        return ImageContent(imagePath, audio: audio);

      case SlotAssemblyTargetType.word:
      case SlotAssemblyTargetType.wordWithAudio:
        return TextContent(_formatText(word.word), audio: audio);

      case SlotAssemblyTargetType.audio:
        return audio;
    }
  }

  TaskContent _createSyllableContent(String syllable) {
    final formattedSyllable = _formatText(syllable);

    if (!syllableHasSound) {
      return TextContent(formattedSyllable);
    }

    final audioPath = syllableAudio[_normalize(syllable)]?.trim();

    if (audioPath == null || audioPath.isEmpty) {
      return TextContent(formattedSyllable);
    }

    return TextContent(
      formattedSyllable,
      audio: AudioContent.fixed(_resolveAudioPath(audioPath)),
    );
  }

  String _resolveAudioPath(String audio) {
    final value = audio.trim();

    if (value.startsWith('assets/')) {
      return value;
    }

    return '$_pronunciationAudioDirectory$value';
  }

  static String _normalize(String value) {
    return value.trim().toLowerCase();
  }

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
        maskIndex++;
        textIndex++;
      } else if (maskIndex < mask.length && mask[maskIndex] == 0x2A) {
        lastStarIndex = maskIndex;
        retryTextIndex = textIndex;
        maskIndex++;
      } else if (lastStarIndex != -1) {
        maskIndex = lastStarIndex + 1;
        retryTextIndex++;
        textIndex = retryTextIndex;
      } else {
        return false;
      }
    }

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

class _SlotAssemblyCandidate {
  const _SlotAssemblyCandidate({
    required this.target,
    required this.correctAnswers,
    required this.wrongAnswers,
  });

  final TaskContent target;
  final List<TaskContent> correctAnswers;
  final List<TaskContent> wrongAnswers;
}
