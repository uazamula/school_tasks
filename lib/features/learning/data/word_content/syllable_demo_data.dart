import 'package:school_tasks/features/learning/domain/word_content/language.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_concept.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_entry.dart';

/// Demo vocabulary for the word ↔ image matching exercise.
///
/// Image paths are relative to the Flutter project's asset root.
final List<WordConcept> syllableDemoConcepts = [
  WordConcept(id: 'anchor', image: 'assets/images/anchor.png'),
  WordConcept(id: 'ants', image: 'assets/images/ants.png'),
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
final List<WordEntry> syllableDemoWords = [
  WordEntry(
    language: Language.uk,
    word: 'якір',
    syllables: ['я', 'кір'],
    conceptId: 'anchor',
  ),
  WordEntry(
    language: Language.uk,
    word: 'мурахи',
    audio: 'uk_murakhy.mp3',
    syllables: ['му', 'ра', 'хи'],
    conceptId: 'ants',
  ),
  WordEntry(
    language: Language.uk,
    word: 'фартух',
    syllables: ['фар', 'тух'],
    conceptId: 'apron',
  ),
  WordEntry(
    language: Language.uk,
    word: 'арка',
    audio: 'uk_arka.mp3',
    syllables: ['ар', 'ка'],
    conceptId: 'arc',
  ),
  WordEntry(
    language: Language.uk,
    word: 'рука',
    audio: 'uk_ruka.mp3',
    syllables: ['ру', 'ка'],
    conceptId: 'arm',
  ),
  WordEntry(
    language: Language.uk,
    word: 'сокира',
    audio: 'uk_sokyra.mp3',
    syllables: ['со', 'ки', 'ра'],
    conceptId: 'axe',
  ),
  WordEntry(
    language: Language.uk,
    word: 'кора',
    audio: 'uk_kora.mp3',
    syllables: ['ко', 'ра'],
    conceptId: 'bark',
  ),
  WordEntry(
    language: Language.uk,
    word: 'береза',
    audio: 'uk_bereza.mp3',
    syllables: ['бе', 'ре', 'за'],
    conceptId: 'birch',
  ),
  WordEntry(
    language: Language.uk,
    word: 'сир',
    audio: 'uk_syr.mp3',
    syllables: ['сир'],
    conceptId: 'cheese',
  ),
  WordEntry(
    language: Language.uk,
    word: 'гепард',
    syllables: ['ге', 'пард'],
    conceptId: 'cheetah',
  ),
  WordEntry(
    language: Language.uk,
    word: 'корова',
    audio: 'uk_korova.mp3',
    syllables: ['ко', 'ро', 'ва'],
    conceptId: 'cow',
  ),
  WordEntry(
    language: Language.uk,
    word: 'риба',
    audio: 'uk_ryba.mp3',
    syllables: ['ри', 'ба'],
    conceptId: 'fish',
  ),
  WordEntry(
    language: Language.uk,
    word: 'роги',
    syllables: ['ро', 'ги'],
    conceptId: 'horns',
  ),
  WordEntry(language: Language.uk, word: 'marlin', conceptId: 'marlin'),
  WordEntry(
    language: Language.uk,
    word: 'рот',
    audio: 'uk_rot.mp3',
    syllables: ['рот'],
    conceptId: 'mouth',
  ),
  WordEntry(language: Language.uk, word: 'сапсан', conceptId: 'peregrine'),
  WordEntry(
    language: Language.uk,
    word: 'ріка',
    syllables: ['рі', 'ка'],
    conceptId: 'river',
  ),
];
