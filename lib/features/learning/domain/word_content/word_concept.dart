import 'audio_role.dart';
import 'content_tag.dart';

class WordConcept {
  WordConcept({
    required this.id,
    this.image,
    Set<ContentTag> tags = const {},
    Map<AudioRole, String> audioResources = const {},
  }) : tags = Set.unmodifiable(tags),
       audioResources = Map.unmodifiable(audioResources);

  final String id;
  final String? image;
  final Set<ContentTag> tags;
  final Map<AudioRole, String> audioResources;
}
