enum GradeScale { hundred, twelve }

extension GradeScaleExtension on GradeScale {
  String formatScore(double score) {
    final normalizedScore = score.clamp(0.0, 1.0);

    switch (this) {
      case GradeScale.hundred:
        return '${(normalizedScore * 100).round()}%';

      case GradeScale.twelve:
        return '${toTwelveGrade(score)}';
    }
  }

  int toTwelveGrade(double score) {
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
