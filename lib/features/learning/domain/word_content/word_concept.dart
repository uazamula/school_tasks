import 'audio_role.dart';
import 'content_tag.dart';

class WordConcept {
  WordConcept({
    required this.id,
    this.image,
    this.emoji,
    Set<ContentTag> tags = const {},
    Map<AudioRole, String> audioResources = const {},
  }) : tags = Set.unmodifiable(tags),
       audioResources = Map.unmodifiable(audioResources);

  final String id;

  /// Шлях до зображення (`assets/images/ants.png`).
  final String? image;

  /// Емодзі як альтернатива зображенню (`🍐`). Якщо задані і зображення,
  /// і емодзі, генератори віддають перевагу зображенню.
  final String? emoji;

  final Set<ContentTag> tags;
  final Map<AudioRole, String> audioResources;

  /// Чи є непорожній шлях до зображення.
  bool get hasImage => image?.trim().isNotEmpty ?? false;

  /// Чи є непорожнє емодзі.
  bool get hasEmoji => emoji?.trim().isNotEmpty ?? false;

  /// Чи є хоч якийсь візуал: зображення або емодзі.
  bool get hasPicture => hasImage || hasEmoji;
}
