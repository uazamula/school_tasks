import 'language.dart';

class SyllableAudio {
  const SyllableAudio({
    required this.language,
    required this.syllable,
    required this.audio,
    this.profileId,
  });

  final Language language;
  final String syllable;
  final String audio;

  /// Необов'язковий профіль вимови.
  final String? profileId;
}
