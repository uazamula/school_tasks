import 'package:school_tasks/features/learning/domain/evaluation/grade_scale.dart';
import 'package:school_tasks/features/learning/domain/evaluation/topic_result_attempt.dart';

/// Програмні перемикачі застосунку (змінюються в коді).
abstract final class AppConfig {
  const AppConfig._();
  /// Сплеш: текст, емодзі та мінімальний час показу (потім локалізуємо).
  static const splashEmoji = '🎒';
  static const splashTitle = 'Шкільні завдання';
  static const splashHint = 'Завантажуємо...';
  static const splashMinDuration = Duration(seconds: 1, milliseconds: 700);

  /// Дитячий інтерфейс за замовчуванням, поки користувач нічого не обрав.
  static const kidsUiDefault = true;

  /// Чи показувати перемикач дитячого інтерфейсу в налаштуваннях.
  static const kidsUiSwitchVisible = true;

  /// Яку спробу показувати на плитці, поки користувач не обрав сам.
  static const resultAttemptDefault = TopicResultAttempt.current;
  static const kidsResultAttemptDefault = TopicResultAttempt.best;

  /// Шкала оцінювання, поки користувач не обрав сам.
  static const gradeScaleDefault = GradeScale.hundred;
  static const kidsGradeScaleDefault = GradeScale.emoji;
}
