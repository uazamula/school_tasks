import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/target_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_prompt/circle_reveal_image.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_prompt/color_depth_image.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_prompt/prompt_content_builder.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_prompt/sharpen_image.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_prompt/wipe_reveal_image.dart';

class PromptTargetView extends StatelessWidget {
  const PromptTargetView({
    super.key,
    required this.target,
    required this.targetProgress,
    required this.contentBuilder,
    this.totalSlots,
    this.feedbackDuration,
    this.textStyle,
  });

  /// Тривалість фідбеку теми; від неї залежить фінальне розкриття.
  final Duration? feedbackDuration;

  final TargetContent target;

  /// Кількість правильно заповнених слотів.
  final int targetProgress;

  /// Загальна кількість слотів. null — невідома наперед.
  final int? totalSlots;

  final PromptContentBuilder contentBuilder;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final effect = target.effect;
    final item = target.target;
    final style = _targetTextStyle(item);

    if (effect == null) return _buildContent(context, style);

    final steps = effect.resolveSteps(totalSlots);

    switch (effect.type) {
      case TargetEffectType.saturation:
        final progress = (targetProgress / steps).clamp(0.0, 1.0).toDouble();
        if (item is! ImageContent || progress >= 1.0) {
          return _buildContent(context, style);
        }
        return ColorFiltered(
          colorFilter: ColorFilter.matrix(_saturationMatrix(progress)),
          child: _buildContent(context, style),
        );

      case TargetEffectType.glow:
        if (item is! TextContent) return _buildContent(context, style);
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(end: _glowIntensity(targetProgress, steps)),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutBack,
          builder: (context, intensity, _) {
            final i = intensity.clamp(0.0, 1.0).toDouble();
            return Transform.scale(
              scale: 1 + 0.12 * i,
              child: _buildContent(context, _glowStyle(context, style, i)),
            );
          },
        );
      case TargetEffectType.retroColorDepth:
      case TargetEffectType.adaptiveColorDepth:
        if (item is! ImageContent) return _buildContent(context, style);

        final adaptive = effect.type == TargetEffectType.adaptiveColorDepth;
        final level = adaptive
            ? effect.colorsForProgress(targetProgress, steps)
            : effect.bitsForProgress(targetProgress, steps);

        return contentBuilder.build(
          context,
          item,
          style,
          fullWidthText: true,
          imageBuilder: (image) => ColorDepthImage(
            assetPath: image.imagePath,
            level: level,
            mode: adaptive ? ColorDepthMode.adaptive : ColorDepthMode.retro,
          ),
        );
      case TargetEffectType.circleReveal:
        if (item is! ImageContent) return _buildContent(context, style);

        final reveal = effect.reveal;
        final isFinal = targetProgress >= steps;

        return contentBuilder.build(
          context,
          item,
          style,
          fullWidthText: true,
          imageBuilder: (image) => CircleRevealImage(
            assetPath: image.imagePath,
            stage: _revealStage(targetProgress, steps),
            config: reveal,
            duration: isFinal
                ? _finalRevealDuration(reveal)
                : reveal.stepDuration,
          ),
        );
      case TargetEffectType.blurSharpen:
      case TargetEffectType.mosaicSharpen:
        if (item is! ImageContent) return _buildContent(context, style);

        final sharpen = effect.sharpen;
        final mode = effect.type == TargetEffectType.blurSharpen
            ? SharpenMode.blur
            : SharpenMode.mosaic;

        return contentBuilder.build(
          context,
          item,
          style,
          fullWidthText: true,
          imageBuilder: (image) => SharpenImage(
            assetPath: image.imagePath,
            progress: math.min(math.max(targetProgress, 0), steps),
            steps: steps,
            mode: mode,
            config: sharpen,
            duration: _sharpenDuration(sharpen),
          ),
        );
      case TargetEffectType.wipeReveal:
        final wipe = effect.wipe;
        if (item is! ImageContent || wipe == null) {
          return _buildContent(context, style);
        }

        return contentBuilder.build(
          context,
          item,
          style,
          fullWidthText: true,
          imageBuilder: (image) => WipeRevealImage(
            assetPath: image.imagePath,
            progress: targetProgress,
            steps: steps,
            config: wipe,
            duration: _wipeDuration(wipe),
          ),
        );
    }
  }

  Duration _wipeDuration(WipeRevealConfig wipe) {
    var duration = wipe.stepDuration;

    // Не довше 80 % від feedbackDuration.
    final feedback = feedbackDuration;
    if (feedback != null) {
      final cap = feedback * 0.8;
      if (cap < duration) duration = cap;
    }

    // Дуже короткий перехід — миттєво.
    return duration < const Duration(milliseconds: 80)
        ? Duration.zero
        : duration;
  }

  Duration _sharpenDuration(SharpenConfig sharpen) {
    var duration = sharpen.stepDuration;

    // Не довше 80 % від feedbackDuration.
    final feedback = feedbackDuration;
    if (feedback != null) {
      final cap = feedback * 0.8;
      if (cap < duration) duration = cap;
    }

    // Дуже короткий перехід — миттєво.
    return duration < const Duration(milliseconds: 80)
        ? Duration.zero
        : duration;
  }

  /// 0 — приховано; 0.5…1 — діаметр кола; 2 — відкрито повністю.
  static double _revealStage(int progress, int steps) {
    if (progress <= 0) return 0;
    if (progress >= steps) return 2;
    if (steps == 2) return 1; // перший крок двоскладового = діаметр 1.0
    return 0.5 + 0.5 * (progress - 1) / (steps - 2);
  }

  Duration _finalRevealDuration(CircleRevealConfig reveal) {
    final feedback = feedbackDuration;
    if (feedback == null) return reveal.stepDuration;

    final duration = feedback * reveal.finalDurationFactor;
    // Дуже короткий фідбек: розкриваємо миттєво.
    return duration < const Duration(milliseconds: 80)
        ? Duration.zero
        : duration;
  }

  /// Базовий стиль цілі: для тексту застосовує [TargetContent.fontSize].
  TextStyle? _targetTextStyle(TaskContent item) {
    final size = target.fontSize;
    if (item is! TextContent || size == null) return textStyle;
    return (textStyle ?? const TextStyle()).copyWith(fontSize: size);
  }

  Widget _buildContent(BuildContext context, TextStyle? style) {
    return contentBuilder.build(
      context,
      target.target,
      style,
      fullWidthText: true,
    );
  }

  static double _glowIntensity(int step, int steps) {
    if (step <= 0) return 0;
    final t = (step / steps).clamp(0.0, 1.0).toDouble();
    return 0.3 + 0.7 * t;
  }

  TextStyle? _glowStyle(BuildContext context, TextStyle? baseStyle, double i) {
    if (i <= 0) return baseStyle;

    final scheme = Theme.of(context).colorScheme;
    final base = baseStyle ?? const TextStyle();
    final glow = Color.lerp(scheme.primary, scheme.tertiary, i)!;

    return base.copyWith(
      color: Color.lerp(
        base.color ?? scheme.onSurfaceVariant,
        scheme.primary,
        i,
      ),
      fontWeight: FontWeight.lerp(
        base.fontWeight ?? FontWeight.normal,
        FontWeight.w800,
        i,
      ),
      shadows: [
        Shadow(
          color: glow.withValues(alpha: 0.5 + 0.5 * i),
          blurRadius: 4 + 10 * i,
        ),
        Shadow(
          color: glow.withValues(alpha: 0.9 * i),
          blurRadius: 12 + 24 * i,
        ),
        Shadow(
          color: glow.withValues(alpha: 0.7 * i),
          blurRadius: 24 + 40 * i,
        ),
        Shadow(
          color: glow.withValues(alpha: 0.5 * i),
          blurRadius: 48 * i,
        ),
      ],
    );
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
