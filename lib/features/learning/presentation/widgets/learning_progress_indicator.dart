import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';

class LearningProgressIndicator extends StatelessWidget {
  const LearningProgressIndicator({
    super.key,
    required this.progress,
    required this.totalSteps,
    required this.elapsed,
    this.maximumTime,
  });

  final int progress;
  final int totalSteps;
  final Duration elapsed;
  final Duration? maximumTime;

  static const animationDuration = Duration(milliseconds: 400);
  static const _progressHeight = 12.0;
  static const _borderRadius = 8.0;
  static const _indicatorPadding = 8.0;
  static const _indicatorDiameter = 16.0;
  static const _indicatorBorderWidth = 2.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final progressValue = totalSteps == 0
        ? 0.0
        : (progress / totalSteps).clamp(0.0, 1.0);

    final timeColor = theme.brightness == Brightness.light
        ? colorScheme.onSurface
        : colorScheme.onSurfaceVariant;

    final displayedTime = _displayedTime;

    return Container(
      padding: const EdgeInsets.all(_indicatorPadding),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: _AnimatedProgressBar(
              value: progressValue,
              progressColor: colorScheme.primary,
              indicatorColor: colorScheme.primaryContainer,
              indicatorBorderColor: colorScheme.primary,
              backgroundColor: colorScheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            _formatDuration(displayedTime),
            style: theme.textTheme.titleMedium?.copyWith(color: timeColor),
          ),
        ],
      ),
    );
  }

  Duration get _displayedTime {
    final maximum = maximumTime;

    if (maximum == null) {
      return elapsed;
    }

    final remaining = maximum - elapsed;

    if (remaining.isNegative) {
      return Duration.zero;
    }

    return remaining;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class _AnimatedProgressBar extends StatelessWidget {
  const _AnimatedProgressBar({
    required this.value,
    required this.progressColor,
    required this.indicatorColor,
    required this.indicatorBorderColor,
    required this.backgroundColor,
  });

  final double value;
  final Color progressColor;
  final Color indicatorColor;
  final Color indicatorBorderColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final diameter = LearningProgressIndicator._indicatorDiameter;

        return SizedBox(
          height: diameter,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              LearningProgressIndicator._borderRadius,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 2,
                  height: LearningProgressIndicator._progressHeight,
                  child: ColoredBox(color: backgroundColor),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: value),
                  duration: LearningProgressIndicator.animationDuration,
                  curve: Curves.easeOut,
                  builder: (context, animatedValue, child) {
                    final progressWidth = width * animatedValue;
                    final indicatorRadius = diameter / 2;
                    final indicatorCenter =
                        indicatorRadius + (width - diameter) * animatedValue;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          top: 2,
                          width: progressWidth,
                          height: LearningProgressIndicator._progressHeight,
                          child: ColoredBox(color: progressColor),
                        ),
                        Positioned(
                          left: indicatorCenter - indicatorRadius,
                          top: 0,
                          child: Container(
                            width: diameter,
                            height: diameter,
                            decoration: BoxDecoration(
                              color: indicatorColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: indicatorBorderColor,
                                width: LearningProgressIndicator
                                    ._indicatorBorderWidth,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
