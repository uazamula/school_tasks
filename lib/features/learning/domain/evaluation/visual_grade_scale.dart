import 'grade_scale.dart';
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
    final grade = GradeScale.twelve.toTwelveGrade(score);

    return fromGrade(grade);
  }
}
