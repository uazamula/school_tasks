class VisualGradeLevel {
  const VisualGradeLevel({
    required this.minGrade,
    required this.maxGrade,
    this.emoji,
    this.imageAsset,
    this.name,
  }) : assert(
         emoji != null || imageAsset != null,
         'Either emoji or imageAsset must be provided.',
       );

  final int minGrade;
  final int maxGrade;

  /// Emoji для візуального рівня.
  final String? emoji;

  /// PNG/JPG asset для візуального рівня.
  final String? imageAsset;

  /// Назва тварини. Поки використовується лише як майбутня
  /// основа для accessibility.
  final String? name;

  bool containsGrade(int grade) {
    return grade >= minGrade && grade <= maxGrade;
  }
}
