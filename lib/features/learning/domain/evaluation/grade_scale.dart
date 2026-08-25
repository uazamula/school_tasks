enum GradeScale { hundred, twelve }

extension GradeScaleExtension on GradeScale {
  int convert(double score) {
    final normalizedScore = score.clamp(0.0, 1.0);

    return switch (this) {
      GradeScale.hundred => (normalizedScore * 100).round(),
      GradeScale.twelve => (normalizedScore * 12).round().clamp(1, 12),
    };
  }
}
