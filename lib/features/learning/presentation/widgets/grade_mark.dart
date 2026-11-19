import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/evaluation/emoji_grade_scale.dart';
import 'package:school_tasks/features/learning/domain/evaluation/grade_scale.dart';
import 'package:school_tasks/features/learning/presentation/widgets/visual_grade_scale_widget.dart';

/// Позначка оцінки для всіх шкал. Не зараховану спробу позначає «знизує
/// плечима». Вміст вписується в квадрат [size] зі збереженням пропорцій.
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
    return SizedBox.square(
      dimension: size,
      child: Center(
        child: FittedBox(fit: BoxFit.scaleDown, child: _buildContent()),
      ),
    );
  }

  Widget _buildContent() {
    if (!isPassed) {
      return _emoji(EmojiGradeScale.notPassed);
    }

    return switch (scale) {
      GradeScale.emoji => _emoji(EmojiGradeScale.fromScore(score)),
      GradeScale.visual => VisualGradeScaleWidget(score: score, size: size),
      GradeScale.hundred || GradeScale.twelve => Text(
        scale.formatScore(score),
        maxLines: 1,
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    };
  }

  Widget _emoji(String value) {
    return Text(value, style: TextStyle(fontSize: size, height: 1));
  }
}
