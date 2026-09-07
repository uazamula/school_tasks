import 'package:flutter/material.dart';

import 'package:school_tasks/features/learning/domain/evaluation/visual_grade_scale.dart';

class VisualGradeScaleWidget extends StatelessWidget {
  const VisualGradeScaleWidget({
    super.key,
    required this.score,
    this.size = 32,
  });

  /// Нормалізована оцінка від 0 до 1.
  final double score;

  /// Розмір візуального елемента.
  final double size;

  @override
  Widget build(BuildContext context) {
    final level = VisualGradeScale.fromScore(score);

    if (level.imageAsset != null) {
      return Image.asset(
        level.imageAsset!,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    }

    if (level.emoji != null) {
      return Text(level.emoji!, style: TextStyle(fontSize: size));
    }

    return SizedBox(width: size, height: size);
  }
}
