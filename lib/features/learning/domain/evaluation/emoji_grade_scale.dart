/// Емодзі-шкала за підсумковою оцінкою (0–1), а не за точністю:
/// в оцінку може входити й час.
abstract final class EmojiGradeScale {
  static const String notPassed = '🤷';

  static String fromScore(double score) {
    // Невелика похибка: ідеальна спроба може дати 0.99999.
    if (score >= 0.9999) return '🥇';
    if (score >= 0.8) return '🥈';
    if (score >= 0.5) return '🥉';
    return '👏';
  }
}
