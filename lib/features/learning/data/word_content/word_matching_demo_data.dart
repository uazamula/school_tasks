import 'package:school_tasks/features/learning/domain/word_content/language.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_concept.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_entry.dart';

/// Demo vocabulary for the word ↔ image matching exercise.
///
/// Image paths are relative to the Flutter project's asset root.
final List<WordConcept> wordMatchingDemoConcepts = [
  WordConcept(id: 'anchor', image: 'assets/images/anchor.png'),
  WordConcept(id: 'ant', image: 'assets/images/ant.png'),
  WordConcept(id: 'apron', image: 'assets/images/apron.png'),
  WordConcept(id: 'arc', image: 'assets/images/arc.png'),
  WordConcept(id: 'arm', image: 'assets/images/arm.png'),
  WordConcept(id: 'axe', image: 'assets/images/axe.png'),
  WordConcept(id: 'bark', image: 'assets/images/bark.jpg'),
  WordConcept(id: 'birch', image: 'assets/images/birch.png'),
  WordConcept(id: 'cheese', image: 'assets/images/cheese.png'),
  WordConcept(id: 'cheetah', image: 'assets/images/cheetah.png'),
  WordConcept(id: 'cow', image: 'assets/images/cow.png'),
  WordConcept(id: 'fish', image: 'assets/images/fish.png'),
  WordConcept(id: 'horns', image: 'assets/images/horns.png'),
  WordConcept(id: 'marlin', image: 'assets/images/marlin.png'),
  WordConcept(id: 'mouth', image: 'assets/images/mouth.png'),
  WordConcept(id: 'peregrine', image: 'assets/images/peregrine.png'),
  WordConcept(id: 'river', image: 'assets/images/river.png'),
];

/// English words linked to the concepts above.
final List<WordEntry> wordMatchingDemoWords = [
  WordEntry(language: Language.en, word: 'anchor', conceptId: 'anchor'),
  WordEntry(language: Language.en, word: 'ant', conceptId: 'ant'),
  WordEntry(language: Language.en, word: 'apron', conceptId: 'apron'),
  WordEntry(language: Language.en, word: 'arc', conceptId: 'arc'),
  WordEntry(language: Language.en, word: 'arm', conceptId: 'arm'),
  WordEntry(language: Language.en, word: 'axe', conceptId: 'axe'),
  WordEntry(language: Language.en, word: 'bark', conceptId: 'bark'),
  WordEntry(language: Language.en, word: 'birch', conceptId: 'birch'),
  WordEntry(language: Language.en, word: 'cheese', conceptId: 'cheese'),
  WordEntry(language: Language.en, word: 'cheetah', conceptId: 'cheetah'),
  WordEntry(language: Language.en, word: 'cow', conceptId: 'cow'),
  WordEntry(language: Language.en, word: 'fish', conceptId: 'fish'),
  WordEntry(language: Language.en, word: 'horns', conceptId: 'horns'),
  WordEntry(language: Language.en, word: 'marlin', conceptId: 'marlin'),
  WordEntry(language: Language.en, word: 'mouth', conceptId: 'mouth'),
  WordEntry(language: Language.en, word: 'peregrine', conceptId: 'peregrine'),
  WordEntry(language: Language.en, word: 'river', conceptId: 'river'),
];
