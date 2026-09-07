enum GradeScale { hundred, twelve }

extension GradeScaleExtension on GradeScale {
  String formatScore(double score) {
    final normalizedScore = score.clamp(0.0, 1.0);

    switch (this) {
      case GradeScale.hundred:
        return '${(normalizedScore * 100).round()}%';

      case GradeScale.twelve:
        return twelveGrade(normalizedScore).toString();
    }
  }

  /// Перетворює нормалізований результат 0..1
  /// у 12-бальну оцінку відповідно до таблиці:
  ///
  /// 98–100% → 12
  /// 93–97%  → 11
  /// 90–92%  → 10
  /// 85–89%  → 9
  /// 78–84%  → 8
  /// 72–77%  → 7
  /// 65–71%  → 6
  /// 57–64%  → 5
  /// 50–56%  → 4
  /// 35–49%  → 3
  /// 15–34%  → 2
  /// 0–14%   → 1
  int twelveGrade(double score) {
    final percentage = score.clamp(0.0, 1.0) * 100;

    if (percentage >= 98) return 12;
    if (percentage >= 93) return 11;
    if (percentage >= 90) return 10;
    if (percentage >= 85) return 9;
    if (percentage >= 78) return 8;
    if (percentage >= 72) return 7;
    if (percentage >= 65) return 6;
    if (percentage >= 57) return 5;
    if (percentage >= 50) return 4;
    if (percentage >= 35) return 3;
    if (percentage >= 15) return 2;

    return 1;
  }
}
