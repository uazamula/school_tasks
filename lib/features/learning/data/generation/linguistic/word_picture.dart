import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_concept.dart';

/// Візуальний контент концепту: зображення, а якщо його немає — емодзі.
/// Якщо немає нічого, повертає null.
TaskContent? createPictureContent(WordConcept concept, {AudioContent? audio}) {
  if (concept.hasImage) {
    return ImageContent(concept.image!.trim(), audio: audio);
  }

  if (concept.hasEmoji) {
    return EmojiContent(concept.emoji!.trim(), audio: audio);
  }

  return null;
}
