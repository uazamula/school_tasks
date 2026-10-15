import 'package:school_tasks/features/learning/data/generation/task_data_generator.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/word_content/language.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_concept.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_entry.dart';

class WordMatchingTaskDataGenerator extends TaskDataGenerator {
  WordMatchingTaskDataGenerator({
    required List<WordEntry> words,
    required List<WordConcept> concepts,
    required this.taskCount,
    required this.pairCount,
    this.language = Language.uk,
    this.prompt = const TaskPrompt(
      content: [TextContent('Зістав слово із зображенням')],
    ),
  }) : _words = List.unmodifiable(words),
       _concepts = List.unmodifiable(concepts);

  final List<WordEntry> _words;
  final List<WordConcept> _concepts;

  /// Кількість завдань, які потрібно створити.
  final int taskCount;

  /// Кількість пар, які показуються в одному завданні.
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

    final conceptsById = {for (final concept in _concepts) concept.id: concept};

    final pairs = <MatchingPair>[];

    for (final word in _words) {
      if (word.language != language) {
        continue;
      }

      final conceptId = word.conceptId;
      if (conceptId == null) {
        continue;
      }

      final concept = conceptsById[conceptId];
      if (concept == null) {
        continue;
      }

      final image = concept.image;
      if (image == null || image.isEmpty) {
        continue;
      }

      pairs.add(
        MatchingPair(left: TextContent(word.word), right: ImageContent(image)),
      );
    }

    if (pairs.isEmpty) {
      throw StateError('No matching pairs found for language $language.');
    }

    if (pairCount > pairs.length) {
      throw StateError(
        'Requested $pairCount pairs, but only '
        '${pairs.length} matching pairs are available.',
      );
    }

    return List.generate(
      taskCount,
      (_) => MatchingTaskData(
        prompt: prompt,
        pairs: List.unmodifiable(pairs),
        pairCount: pairCount,
      ),
    );
  }
}
