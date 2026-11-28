import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/data/generation/linguistic/matching_text_case.dart';
import 'package:school_tasks/features/learning/domain/word_content/language.dart';

/// Абетки мов (нижній регістр). Апостроф і дефіс не входять.
abstract final class Alphabets {
  static final List<String> uk = 'абвгґдеєжзиіїйклмнопрстуфхцчшщьюя'.split('');

  static final List<String> en = 'abcdefghijklmnopqrstuvwxyz'.split('');

  static final List<String> tr = 'abcçdefgğhıijklmnoöprsştuüvyz'.split('');

  static List<String> of(Language language) => switch (language) {
    Language.uk => uk,
    Language.en => en,
    Language.tr => tr,
  };

  // Апостроф, дефіс і пробіли у слові ігноруються.
  static final RegExp _ignoredChars = RegExp(r"[\s\-'’ʼ`]");

  /// Літери слова в нижньому регістрі без апострофів, дефісів і пробілів.
  /// null, якщо слово порожнє або має символи поза абеткою мови.
  static List<String>? lettersOf(String word, Language language) {
    final lower = MatchingTextCase.lowercase
        .format(word, language)
        .replaceAll(_ignoredChars, '');

    final letters = lower.characters.toList();
    final alphabet = of(language);

    if (letters.isEmpty || !letters.every(alphabet.contains)) return null;

    return letters;
  }
}
