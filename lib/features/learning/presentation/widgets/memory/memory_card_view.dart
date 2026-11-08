import 'dart:math';

import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/task_data/memory_card_style_config.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/memory_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';

class MemoryCardView extends StatelessWidget {
  const MemoryCardView({
    super.key,
    required this.pair,
    required this.isB,
    required this.size,
    required this.style,
    required this.flipDuration,
    required this.showBack,
    required this.removed,
    required this.shakeToken,
    this.onTap,
  });

  static const removeDuration = Duration(milliseconds: 250);

  final MemoryPair pair;
  final bool isB;
  final Size size;
  final MemoryCardStyleConfig style;
  final Duration flipDuration;
  final bool showBack;
  final bool removed;
  final int shakeToken;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;

    Color? pick(MemoryFaceStyle s) =>
        dark ? s.darkBackgroundColor : s.lightBackgroundColor;

    final Widget front;
    final Widget? back;

    if (isB) {
      front = _cover(context, pick, scheme);
      back = _face(
        pair.hiddenContent,
        style.hiddenFace,
        pick(style.hiddenFace) ?? scheme.surface,
        scheme,
      );
    } else {
      front = _face(
        pair.faceFront,
        style.front,
        pick(style.front) ?? scheme.secondaryContainer,
        scheme,
      );
      final faceBack = pair.faceBack;
      back = faceBack == null
          ? null
          : _face(
              faceBack,
              style.back,
              pick(style.back) ?? scheme.surface,
              scheme,
            );
    }

    final flip = _Flip(
      showBack: showBack && back != null,
      duration: flipDuration,
      front: front,
      back: back,
    );

    // Зміна shakeToken перезапускає анімацію струсу.
    final shaking = TweenAnimationBuilder<double>(
      key: ValueKey(shakeToken),
      tween: Tween(begin: shakeToken == 0 ? 1.0 : 0.0, end: 1.0),
      duration: const Duration(milliseconds: 350),
      builder: (context, t, child) => Transform.translate(
        offset: Offset(sin(t * pi * 4) * 6 * (1 - t), 0),
        child: child,
      ),
      child: flip,
    );

    return IgnorePointer(
      ignoring: removed,
      child: AnimatedOpacity(
        opacity: removed ? 0 : 1,
        duration: removeDuration,
        child: AnimatedScale(
          scale: removed ? 0.6 : 1,
          duration: removeDuration,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: shaking,
            ),
          ),
        ),
      ),
    );
  }

  double get _fontSize => size.shortestSide * 0.28;

  Widget _cover(
    BuildContext context,
    Color? Function(MemoryFaceStyle) pick,
    ColorScheme scheme,
  ) {
    final cover = style.cover;

    return _frame(
      color: pick(cover.face) ?? scheme.primaryContainer,
      scheme: scheme,
      padding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (cover.imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.asset(cover.imagePath!, fit: BoxFit.cover),
            ),
          if (cover.text != null)
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  cover.text!,
                  style: TextStyle(
                    fontSize: _fontSize,
                    color: scheme.onPrimaryContainer,
                  ).merge(cover.face.textStyle),
                  textScaler: cover.face.textScaler,
                ),
              ),
            ),
          if (cover.text == null && cover.imagePath == null)
            Center(
              child: Icon(
                Icons.help_outline,
                size: size.shortestSide * 0.4,
                color: scheme.onPrimaryContainer,
              ),
            ),
        ],
      ),
    );
  }

  Widget _face(
    TaskContent content,
    MemoryFaceStyle faceStyle,
    Color color,
    ColorScheme scheme,
  ) {
    return _frame(
      color: color,
      scheme: scheme,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Center(
        child: MemoryCardContent(
          content: content,
          textStyle: TextStyle(
            fontSize: _fontSize,
            color: scheme.onSurface,
          ).merge(faceStyle.textStyle),
          textScaler: faceStyle.textScaler,
          emojiSize: size.shortestSide * 0.5,
        ),
      ),
    );
  }

  Widget _frame({
    required Color color,
    required ColorScheme scheme,
    required EdgeInsets padding,
    required Widget child,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: child,
    );
  }
}

/// Вміст картки без аудіо: звук грає віджет завдання, одним плеєром.
class MemoryCardContent extends StatelessWidget {
  const MemoryCardContent({
    super.key,
    required this.content,
    required this.textStyle,
    this.textScaler,
    this.emojiSize = 40,
  });

  final TaskContent content;
  final TextStyle textStyle;
  final TextScaler? textScaler;
  final double emojiSize;

  @override
  Widget build(BuildContext context) {
    final c = content;

    if (c is TextContent) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          c.text,
          textAlign: TextAlign.center,
          style: textStyle,
          textScaler: textScaler,
        ),
      );
    }

    if (c is EmojiContent) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(c.emoji, style: TextStyle(fontSize: emojiSize)),
      );
    }

    if (c is ImageContent) {
      return Image.asset(c.imagePath, fit: BoxFit.contain);
    }

    if (c is AudioContent) {
      return Icon(Icons.volume_up, size: emojiSize);
    }

    if (c is GridContent) {
      return GridView.count(
        crossAxisCount: c.columns,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          c.rows * c.columns,
          (_) => MemoryCardContent(
            content: c.item,
            textStyle: textStyle,
            textScaler: textScaler,
            emojiSize: emojiSize / max(c.rows, c.columns),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _Flip extends StatelessWidget {
  const _Flip({
    required this.showBack,
    required this.duration,
    required this.front,
    required this.back,
  });

  final bool showBack;
  final Duration duration;
  final Widget front;
  final Widget? back;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: showBack ? 1.0 : 0.0),
      duration: duration,
      builder: (context, value, _) {
        final isBack = value > 0.5 && back != null;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(value * pi),
          child: isBack
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: back,
                )
              : front,
        );
      },
    );
  }
}
