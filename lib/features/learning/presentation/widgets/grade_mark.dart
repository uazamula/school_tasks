import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/evaluation/emoji_grade_scale.dart';
import 'package:school_tasks/features/learning/domain/evaluation/grade_scale.dart';
import 'package:school_tasks/features/learning/presentation/widgets/visual_grade_scale_widget.dart';

/// Графічна позначка оцінки для візуальної та емодзі-шкал.
/// Не зараховану спробу позначає «знизує плечима».
class GradeMark extends StatelessWidget {
  const GradeMark({
    super.key,
    required this.score,
    required this.isPassed,
    required this.scale,
    required this.size,
  });

  final double score;
  final bool isPassed;
  final GradeScale scale;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (!isPassed) {
      return _emoji(EmojiGradeScale.notPassed);
    }

    if (scale == GradeScale.emoji) {
      return _emoji(EmojiGradeScale.fromScore(score));
    }

    return VisualGradeScaleWidget(score: score, size: size);
  }

  Widget _emoji(String value) {
    return Text(value, style: TextStyle(fontSize: size, height: 1));
  }
}
