/// Шляхи до аудіоресурсів.
abstract final class AudioPaths {
  /// Папка з озвученням слів і складів.
  static const String pronunciationDirectory = 'assets/audio/pronunciation/';

  /// Повний шлях до файлу вимови. Якщо шлях уже починається з 'assets/',
  /// він лишається без змін.
  static String resolvePronunciation(String audio) {
    final value = audio.trim();

    if (value.startsWith('assets/')) {
      return value;
    }

    return '$pronunciationDirectory$value';
  }
}
