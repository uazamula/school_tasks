import 'visual_grade_level.dart';

abstract final class VisualGradeScale {
  static const List<VisualGradeLevel> levels = [
    VisualGradeLevel(minGrade: 1, maxGrade: 4, name: 'Равлик', emoji: '🐌'),
    VisualGradeLevel(minGrade: 5, maxGrade: 5, name: 'Черепаха', emoji: '🐢'),
    VisualGradeLevel(minGrade: 6, maxGrade: 6, name: 'Їжак', emoji: '🦔'),
    VisualGradeLevel(minGrade: 7, maxGrade: 7, name: 'Кролик', emoji: '🐇'),
    VisualGradeLevel(minGrade: 8, maxGrade: 8, name: 'Собака', emoji: '🐕'),
    VisualGradeLevel(minGrade: 9, maxGrade: 9, name: 'Олень', emoji: '🦌'),
    VisualGradeLevel(
      minGrade: 10,
      maxGrade: 10,
      name: 'Риба-меч',
      imageAsset: 'assets/images/marlin.png',
    ),
    VisualGradeLevel(
      minGrade: 11,
      maxGrade: 11,
      name: 'Гепард',
      imageAsset: 'assets/images/cheetah.png',
    ),
    VisualGradeLevel(
      minGrade: 12,
      maxGrade: 12,
      name: 'Сапсан',
      imageAsset: 'assets/images/peregrine.png',
    ),
  ];

  static VisualGradeLevel fromGrade(int grade) {
    final normalizedGrade = grade.clamp(1, 12);

    return levels.firstWhere((level) => level.containsGrade(normalizedGrade));
  }

  static VisualGradeLevel fromScore(double score) {
    final grade = _twelveGrade(score);

    return fromGrade(grade);
  }

  static int _twelveGrade(double score) {
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
