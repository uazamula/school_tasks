import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/target_content.dart';

/// Зображення, закрите картинкою-накривкою, яка відкриває його зліва
/// направо (ширина ≥ висоти) або згори донизу (висота > ширини).
/// [progress] від 0 до [steps]; на [steps] накривка прибирається.
class WipeRevealImage extends StatefulWidget {
  const WipeRevealImage({
    super.key,
    required this.assetPath,
    required this.progress,
    required this.steps,
    required this.config,
    required this.duration,
  });

  final String assetPath;
  final int progress;
  final int steps;
  final WipeRevealConfig config;
  final Duration duration;

  @override
  State<WipeRevealImage> createState() => _WipeRevealImageState();
}

class _WipeRevealImageState extends State<WipeRevealImage> {
  static const _clear = Color(0x00FFFFFF);
  static const _solid = Color(0xFFFFFFFF);

  /// Запас навколо цілі, щоб дробові розміри не лишали смужку
  /// накривки поза маскою.
  static const double _bleed = 3;

  ImageStream? _stream;
  ImageStreamListener? _listener;
  bool _coverReady = false;
  bool _coverFailed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolve();
  }

  @override
  void didUpdateWidget(WipeRevealImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config.coverAsset != widget.config.coverAsset) {
      _coverReady = false;
      _coverFailed = false;
      _resolve();
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  /// Чекаємо, поки накривка завантажиться: до цього ціль приховано,
  /// щоб на перший кадр не «спойлерити» чітку картинку.
  void _resolve() {
    _unsubscribe();

    var resolving = true;

    final stream = AssetImage(
      widget.config.coverAsset,
    ).resolve(createLocalImageConfiguration(context));

    final listener = ImageStreamListener(
      (info, synchronousCall) {
        if (_coverReady) return;
        if (resolving) {
          _coverReady = true; // ще до build, setState не потрібен
        } else if (mounted) {
          setState(() => _coverReady = true);
        }
      },
      onError: (error, stackTrace) {
        debugPrint(
          'WipeRevealImage: не вдалося завантажити '
          '"${widget.config.coverAsset}": $error',
        );
        if (resolving) {
          _coverFailed = true;
        } else if (mounted) {
          setState(() => _coverFailed = true);
        }
      },
    );

    stream.addListener(listener);
    resolving = false;

    _stream = stream;
    _listener = listener;
  }

  void _unsubscribe() {
    final listener = _listener;
    if (listener != null) _stream?.removeListener(listener);
    _stream = null;
    _listener = null;
  }

  @override
  Widget build(BuildContext context) {
    final target = Image.asset(widget.assetPath, fit: BoxFit.contain);

    // Якщо накривку не вдалося завантажити, показуємо ціль без ефекту.
    if (_coverFailed) return target;

    final steps = widget.steps;
    final progress = widget.progress < 0
        ? 0
        : (widget.progress > steps ? steps : widget.progress);
    final t = progress / steps;

    // Center дає Stack «вільні» обмеження, тож він стискається до розміру
    // показаної цілі (BoxFit.contain). Накривка займає саме цей прямокутник.
    return Center(
      child: Stack(
        children: [
          Opacity(opacity: _coverReady ? 1 : 0, child: target),
          if (_coverReady)
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(end: t),
                duration: widget.duration,
                curve: Curves.easeOut,
                builder: (context, value, _) => _buildCover(value),
              ),
            ),
        ],
      ),
    );
  }

  Widget _cover() => Image.asset(
    widget.config.coverAsset,
    fit: BoxFit.cover, // збільшення й обрізання без зміни пропорцій
    alignment: Alignment.center, // обрізання по центру
    gaplessPlayback: true,
  );

  Widget _buildCover(double value) {
    // Повністю відкрито: накривку прибираємо, щоб не лишалося смужки.
    if (value >= 1 - 1e-3) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = constraints.maxWidth >= constraints.maxHeight;

        // ClipRect: накривка не виходить за межі цілі.
        return ClipRect(
          child: switch (widget.config.style) {
            WipeRevealStyle.curtain => _buildCurtain(value, horizontal),
            WipeRevealStyle.slide => _buildSlide(
              value,
              horizontal,
              horizontal ? constraints.maxWidth : constraints.maxHeight,
            ),
          },
        );
      },
    );
  }

  // Шторка: накривка нерухома, маска прибирає її шматок за шматком.
  Widget _buildCurtain(double t, bool horizontal) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -_bleed,
          top: -_bleed,
          right: -_bleed,
          bottom: -_bleed,
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (bounds) => _curtainShader(bounds, t, horizontal),
            child: _cover(),
          ),
        ),
      ],
    );
  }

  ui.Shader _curtainShader(Rect bounds, double t, bool horizontal) {
    final softness = widget.config.edgeSoftness;

    // Довжина шару разом із запасом і довжина самої цілі.
    final full = horizontal ? bounds.width : bounds.height;
    final visible = full - 2 * _bleed;

    // Позиція на цілі (0…1) → позиція в градієнті з урахуванням запасу.
    double pos(double p) =>
        ((_bleed + p * visible) / full).clamp(0.0, 1.0).toDouble();

    // Центр краю їде від -softness/2 до 1 + softness/2, тож на початку
    // накривка непрозора, а наприкінці повністю прозора.
    final edge = -softness / 2 + t * (1 + softness);
    final lo = (edge - softness / 2).clamp(0.0, 1.0).toDouble();
    final hi = (edge + softness / 2).clamp(0.0, 1.0).toDouble();

    return LinearGradient(
      begin: horizontal ? Alignment.centerLeft : Alignment.topCenter,
      end: horizontal ? Alignment.centerRight : Alignment.bottomCenter,
      colors: const [_clear, _clear, _solid, _solid],
      stops: [0, pos(lo), pos(hi), 1],
    ).createShader(bounds);
  }

  // Ковзання: накривка їде разом із межею й виїжджає за край.
  Widget _buildSlide(double t, bool horizontal, double length) {
    final offset = horizontal ? Offset(t * length, 0) : Offset(0, t * length);

    return Transform.translate(
      offset: offset,
      child: RepaintBoundary(child: _cover()),
    );
  }
}
