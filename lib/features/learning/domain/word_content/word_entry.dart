import 'grammatical_feature.dart';
import 'grammatical_value.dart';
import 'language.dart';
import 'part_of_speech.dart';
import 'word_pronunciation.dart';

class WordEntry {
  WordEntry({
    this.conceptId,
    required this.language,
    required this.word,
    List<String> syllables = const [],
    this.audio,
    this.definition,
    this.partOfSpeech,
    Map<GrammaticalFeature, GrammaticalValue> grammaticalFeatures = const {},
    List<WordPronunciation> pronunciations = const [],
  }) : syllables = List.unmodifiable(syllables),
       grammaticalFeatures = Map.unmodifiable(grammaticalFeatures),
       pronunciations = List.unmodifiable(pronunciations);

  final String? conceptId;
  final Language language;
  final String word;
  final List<String> syllables;

  /// Аудіо вимови за замовчуванням.
  final String? audio;

  final String? definition;
  final PartOfSpeech? partOfSpeech;

  final Map<GrammaticalFeature, GrammaticalValue> grammaticalFeatures;

  /// Варіанти вимови для конкретних профілів.
  final List<WordPronunciation> pronunciations;
}
