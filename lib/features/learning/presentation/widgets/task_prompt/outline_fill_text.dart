import 'dart:math' as math;

import 'package:characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/target_content.dart';

/// Текст, літери якого з прогресом переходять від контуру до заливки.
/// [progress] від 0 до [steps]; на [steps] усі літери залиті.
class OutlineFillText extends StatelessWidget {
  const OutlineFillText({
    super.key,
    required this.text,
    required this.style,
    required this.progress,
    required this.steps,
    required this.config,
    required this.duration,
  });

  final String text;
  final TextStyle? style;
  final int progress;
  final int steps;
  final OutlineFillConfig config;
  final Duration duration;

  @override
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = style ?? const TextStyle();

    final fontSize = base.fontSize ?? 18;
    final strokeWidth = math.max(
      config.minStrokeWidth,
      fontSize * config.strokeFactor,
    );
    final outlineColor = config.outlineColor ?? base.color ?? scheme.onSurface;
    final fillColor = config.fillColor ?? scheme.primary;
    final flashColor = config.flashColor ?? fillColor;

    // Рахуємо графеми, а не кодові точки: діакритика й складені символи
    // лишаються цілими. Пробіли в заливці не враховуються.
    final letters = text.characters.toList();
    final countable = letters.where((c) => c.trim().isNotEmpty).length;

    final t = steps <= 0 ? 1.0 : (progress / steps).clamp(0.0, 1.0).toDouble();

    final flashActive =
        config.finalFlash &&
        config.flashDuration > Duration.zero &&
        steps > 0 &&
        progress >= steps;

    // Спалах починається після завершення заливки: Interval стискає
    // «активну» частину анімації в її кінець.
    final total = duration + config.flashDuration;
    final flashStart = total.inMicroseconds == 0
        ? 0.0
        : duration.inMicroseconds / total.inMicroseconds;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: flashActive ? 1.0 : 0.0),
      duration: total,
      curve: Interval(flashStart, 1.0),
      builder: (context, flashValue, _) {
        // 0 → пік → 0 за час спалаху.
        final pulse = math.sin(math.pi * flashValue);

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(end: t),
          duration: duration,
          curve: Curves.easeOut,
          builder: (context, value, _) {
            final fillSpans = <InlineSpan>[];
            final outlineSpans = <InlineSpan>[];
            var index = 0;

            for (final letter in letters) {
              var a = 0.0; // наскільки літера залита: 0…1

              if (letter.trim().isNotEmpty) {
                a = config.mode == OutlineFillMode.all
                    ? value
                    : (value * countable - index).clamp(0.0, 1.0).toDouble();
                index++;
              }

              final fillAlpha =
                  config.unfilledAlpha + (1 - config.unfilledAlpha) * a;

              fillSpans.add(
                TextSpan(
                  text: letter,
                  style: TextStyle(
                    color: fillColor.withValues(alpha: fillAlpha),
                  ),
                ),
              );

              // Контур поступово набуває кольору заливки.
              outlineSpans.add(
                TextSpan(
                  text: letter,
                  style: TextStyle(
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = strokeWidth
                      ..strokeJoin = StrokeJoin.round
                      ..color = Color.lerp(outlineColor, fillColor, a)!,
                  ),
                ),
              );
            }

            // Світіння додається лише до шару заливки.
            final fillStyle = pulse > 0.001 && config.flashStrength > 0
                ? base.copyWith(shadows: _flashShadows(flashColor, pulse))
                : base;

            // Обидва шари мають однаковий розмір і розкладку, тож збігаються.
            final content = Stack(
              alignment: Alignment.topCenter,
              children: [
                Text.rich(
                  TextSpan(children: fillSpans),
                  style: fillStyle,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                // Контур лише для вигляду, екранні читалки його не дублюють.
                ExcludeSemantics(
                  child: Text.rich(
                    TextSpan(children: outlineSpans),
                    style: base,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ],
            );

            if (pulse <= 0.001 || config.flashScale <= 0) return content;

            return Transform.scale(
              scale: 1 + config.flashScale * pulse,
              child: content,
            );
          },
        );
      },
    );
  }

  List<Shadow> _flashShadows(Color color, double pulse) {
    final s = config.flashStrength;

    double alpha(double a) => (a * pulse * s).clamp(0.0, 1.0).toDouble();

    return [
      Shadow(
        color: color.withValues(alpha: alpha(0.9)),
        blurRadius: 6 + 10 * pulse,
      ),
      Shadow(
        color: color.withValues(alpha: alpha(0.8)),
        blurRadius: 16 + 24 * pulse,
      ),
      Shadow(
        color: color.withValues(alpha: alpha(0.6)),
        blurRadius: 32 + 40 * pulse,
      ),
    ];
  }
}
