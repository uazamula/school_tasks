enum GradeScale { hundred, twelve }

extension GradeScaleExtension on GradeScale {
  String formatScore(double score) {
    final normalizedScore = score.clamp(0.0, 1.0);

    switch (this) {
      case GradeScale.hundred:
        return '${(normalizedScore * 100).round()}%';

      case GradeScale.twelve:
        return '${(normalizedScore * 12).round()}';
    }
  }
}
