import 'package:school_tasks/features/learning/data/generation/task_data_generator.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_button_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/word_content/language.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_concept.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_entry.dart';

/// Generates matching tasks in which learners match an English word to an image.
///
/// Each generated MatchingTaskData contains the same pool of valid pairs.
/// The attempt generator later selects [pairCount] pairs for each task.
class WordMatchingTaskDataGenerator extends TaskDataGenerator {
  WordMatchingTaskDataGenerator({
    required List<WordEntry> words,
    required List<WordConcept> concepts,
    required this.taskCount,
    required this.pairCount,
    this.language = Language.en,
    this.buttonConfig,
    this.prompt = const TaskPrompt(
      content: [TextContent('Зістав слово із зображенням')],
    ),
  }) : _words = List.unmodifiable(words),
       _concepts = List.unmodifiable(concepts);

  final List<WordEntry> _words;
  final List<WordConcept> _concepts;
  final MatchingButtonConfig? buttonConfig;

  /// Number of matching tasks to generate.
  final int taskCount;

  /// Number of pairs available in one displayed task.
  final int pairCount;

  final Language language;
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
      if (imagePath == null || imagePath.isEmpty) continue;

      pairs.add(
        MatchingPair(
          left: TextContent(word.word),
          right: ImageContent(imagePath),
        ),
      );
      usedConceptIds.add(conceptId);
    }

    if (pairs.isEmpty) {
      throw StateError(
        'No matching word-image pairs found for language $language.',
      );
    }

    if (pairCount > pairs.length) {
      throw StateError(
        'Requested $pairCount pairs, but only '
        '${pairs.length} unique matching pairs are available.',
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
}
