import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/word_content/picture_source.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_concept.dart';

/// Візуальний контент концепту відповідно до [source]:
/// - [PictureSource.any]: зображення, а якщо його немає — емодзі;
/// - [PictureSource.imageOnly]: лише зображення;
/// - [PictureSource.emojiOnly]: лише емодзі.
/// Якщо потрібного візуалу немає, повертає null.
TaskContent? createPictureContent(
  WordConcept concept, {
  AudioContent? audio,
  PictureSource source = PictureSource.any,
}) {
  if (source != PictureSource.emojiOnly && concept.hasImage) {
    return ImageContent(concept.image!.trim(), audio: audio);
  }

  if (source != PictureSource.imageOnly && concept.hasEmoji) {
    return EmojiContent(concept.emoji!.trim(), audio: audio);
  }

  return null;
}
