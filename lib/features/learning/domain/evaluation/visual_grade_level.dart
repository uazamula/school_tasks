class VisualGradeLevel {
  const VisualGradeLevel({
    required this.minGrade,
    required this.maxGrade,
    required this.name,
    this.emoji,
    this.imageAsset,
  }) : assert(
         (emoji != null) != (imageAsset != null),
         'Exactly one of emoji or imageAsset must be specified.',
       );

  final int minGrade;
  final int maxGrade;

  /// Назва рівня.
  ///
  /// Поки може бути українською. Пізніше винесемо в l10n.
  final String name;

  /// Emoji для відображення рівня.
  final String? emoji;

  /// Шлях до PNG у assets.
  final String? imageAsset;

  bool containsGrade(int grade) {
    return grade >= minGrade && grade <= maxGrade;
  }
}
