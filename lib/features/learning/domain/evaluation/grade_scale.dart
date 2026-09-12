enum GradeScale { hundred, twelve, visual }

extension GradeScaleExtension on GradeScale {
  String formatScore(double score) {
    final normalizedScore = score.clamp(0.0, 1.0);

    switch (this) {
      case GradeScale.hundred:
        return '${(normalizedScore * 100).round()}%';

      case GradeScale.twelve:
        return '${toTwelveGrade(score)}';

      case GradeScale.visual:
        // У текстовому представленні візуальної шкали
        // використовуємо відсоток.
        return '${(normalizedScore * 100).round()}%';
    }
  }

  int toTwelveGrade(double score) {
    final percentage = score.clamp(0.0, 1.0) * 100;

    if (percentage >= 95) return 12;
    if (percentage >= 90) return 11;
    if (percentage >= 85) return 10;
    if (percentage >= 75) return 9;
    if (percentage >= 65) return 8;
    if (percentage >= 55) return 7;
    if (percentage >= 45) return 6;
    if (percentage >= 40) return 5;
    if (percentage >= 34) return 4;
    if (percentage >= 22) return 3;
    if (percentage >= 10) return 2;

    return 1;
  }
}
