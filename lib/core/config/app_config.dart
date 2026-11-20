import 'package:flutter/material.dart';
import 'package:school_tasks/core/config/ui_profile.dart';
import 'package:school_tasks/core/theme/theme_app_theme_choice.dart';
import 'package:school_tasks/features/learning/domain/evaluation/grade_scale.dart';
import 'package:school_tasks/features/learning/domain/evaluation/topic_result_attempt.dart';
import 'package:school_tasks/features/learning/domain/evaluation/topic_result_display.dart';

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
  static const kidsUiSwitchVisible = false;

  /// Значення за замовчуванням для дорослого інтерфейсу.
  static const adultProfile = UiProfile(
    themeChoice: AppThemeChoice.system,
    gradeScale: GradeScale.hundred,
    resultAttempt: TopicResultAttempt.current,
    resultDisplay: TopicResultDisplay.grade,
    serviceSounds: true,
  );

  /// Значення за замовчуванням для дитячого інтерфейсу.
  static const kidsProfile = UiProfile(
    themeChoice: AppThemeChoice.gentle,
    gradeScale: GradeScale.emoji,
    resultAttempt: TopicResultAttempt.best,
    resultDisplay: TopicResultDisplay.gradeAndDuration,
    serviceSounds: true,
  );

  /// Іконка сплеша (не залежить від шрифту емодзі).
  static const splashIcon = Icons.backpack_rounded;
}
