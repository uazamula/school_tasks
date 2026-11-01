import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/target_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_prompt/prompt_content_builder.dart';

/// Ціль завдання з необовʼязковим ефектом, що залежить від прогресу
/// (наприклад, картинка стає кольоровою в міру заповнення слотів).
class PromptTargetView extends StatelessWidget {
  const PromptTargetView({
    super.key,
    required this.target,
    required this.targetProgress,
    required this.contentBuilder,
    this.textStyle,
  });

  final TargetContent target;

  /// Кількість правильно заповнених слотів.
  final int targetProgress;
  final PromptContentBuilder contentBuilder;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final effect = target.effect;

    final content = contentBuilder.build(
      context,
      target.target,
      textStyle,
      fullWidthText: true,
    );

    if (effect == null || target.target is! ImageContent) {
      return content;
    }

    switch (effect.type) {
      case TargetEffectType.saturation:
        final progress = (targetProgress / effect.steps)
            .clamp(0.0, 1.0)
            .toDouble();

        if (progress >= 1.0) {
          return content;
        }

        return ColorFiltered(
          colorFilter: ColorFilter.matrix(_saturationMatrix(progress)),
          child: content,
        );
    }
  }

  /// Матриця насиченості: 0 — чорно-біле, 1 — оригінал.
  List<double> _saturationMatrix(double s) {
    final r = (1 - s) * 0.2126;
    final g = (1 - s) * 0.7152;
    final b = (1 - s) * 0.0722;

    return [
      r + s, g, b, 0, 0, //
      r, g + s, b, 0, 0, //
      r, g, b + s, 0, 0, //
      0, 0, 0, 1, 0,
    ];
  }
}