import 'language.dart';

class PronunciationProfile {
  const PronunciationProfile({
    required this.id,
    required this.language,
    required this.name,
  });

  final String id;
  final Language language;
  final String name;
}
