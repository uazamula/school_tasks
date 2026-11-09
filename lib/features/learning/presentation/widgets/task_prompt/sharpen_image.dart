import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/target_content.dart';

enum SharpenMode { blur, mosaic }

/// Зображення, яке з прогресом стає чіткішим.
/// [progress] від 0 до [steps]; на [steps] показується оригінал.
class SharpenImage extends StatefulWidget {
  const SharpenImage({
    super.key,
    required this.assetPath,
    required this.progress,
    required this.steps,
    required this.mode,
    required this.config,
    required this.duration,
  });

  final String assetPath;
  final int progress;
  final int steps;
  final SharpenMode mode;
  final SharpenConfig config;
  final Duration duration;

  @override
  State<SharpenImage> createState() => _SharpenImageState();
}

class _SharpenImageState extends State<SharpenImage> {
  ImageStream? _stream;
  ImageStreamListener? _listener;
  Size? _imageSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolve();
  }

  @override
  void didUpdateWidget(SharpenImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _imageSize = null;
      _resolve();
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  /// Розміри файлу потрібні, щоб знати, який прямокутник реально займає
  /// картинка (BoxFit.contain), і рахувати розмиття та клітинки від нього.
  void _resolve() {
    _unsubscribe();

    final stream = AssetImage(
      widget.assetPath,
    ).resolve(createLocalImageConfiguration(context));

    final listener = ImageStreamListener((info, _) {
      final size = Size(
        info.image.width.toDouble(),
        info.image.height.toDouble(),
      );
      if (mounted && size != _imageSize) {
        setState(() => _imageSize = size);
      }
    });

    stream.addListener(listener);
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
    final imageSize = _imageSize;
    if (imageSize == null) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final bounds = Size(
          constraints.hasBoundedWidth ? constraints.maxWidth : imageSize.width,
          constraints.hasBoundedHeight
              ? constraints.maxHeight
              : imageSize.height,
        );
        final shown = applyBoxFit(
          BoxFit.contain,
          imageSize,
          bounds,
        ).destination;

        return Center(
          child: SizedBox(
            width: shown.width,
            height: shown.height,
            child: switch (widget.mode) {
              SharpenMode.blur => _buildBlur(shown),
              SharpenMode.mosaic => _buildMosaic(shown),
            },
          ),
        );
      },
    );
  }

  Widget _original(Size shown) => Image.asset(
    widget.assetPath,
    width: shown.width,
    height: shown.height,
    fit: BoxFit.fill,
  );

  /// Затемнення: 0 — без змін, 1 — чорне.
  Widget _dimmed(Widget child, double dim) {
    if (dim <= 0.001) return child;
    final k = 1 - dim;
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(<double>[
        k, 0, 0, 0, 0, //
        0, k, 0, 0, 0, //
        0, 0, k, 0, 0, //
        0, 0, 0, 1, 0,
      ]),
      child: child,
    );
  }

  // Розмиття змінюється неперервно (анімується частка прогресу).
  Widget _buildBlur(Size shown) {
    final t = widget.progress / widget.steps;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: t),
      duration: widget.duration,
      curve: Curves.easeOut,
      builder: (context, value, _) {
        final remaining = (1 - value).clamp(0.0, 1.0).toDouble();
        if (remaining <= 0.001) return _original(shown);

        final sigma =
            shown.shortestSide * widget.config.blurStrength * remaining;

        Widget image = _original(shown);

        if (sigma >= 0.01) {
          // ClipRect: розмиття не виходить за межі картинки.
          image = ClipRect(
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(
                sigmaX: sigma,
                sigmaY: sigma,
                tileMode: TileMode.clamp,
              ),
              child: image,
            ),
          );
        }

        return _dimmed(image, widget.config.coverDim * remaining);
      },
    );
  }

  // Мозаїка змінюється ступенями; між ними — короткий плавний перехід.
  Widget _buildMosaic(Size shown) {
    final k = widget.progress;
    final isOriginal = k >= widget.steps;

    return AnimatedSwitcher(
      duration: widget.duration,
      child: KeyedSubtree(
        key: ValueKey<int>(isOriginal ? -1 : k),
        child: isOriginal ? _original(shown) : _mosaicLevel(shown, k),
      ),
    );
  }

  Widget _mosaicLevel(Size shown, int k) {
    final config = widget.config;
    final t = k / widget.steps;

    // Клітинки зростають геометрично: різниця 8→16 виглядає так само,
    // як 16→32.
    final cells =
        config.mosaicCells * math.pow(config.mosaicMaxFactor, t).toDouble();
    final cell = shown.shortestSide / cells;

    final columns = math.max(1, (shown.width / cell).round());
    final rows = math.max(1, (shown.height / cell).round());

    // Декодуємо в малому розмірі й розтягуємо без згладжування.
    final image = Image.asset(
      widget.assetPath,
      width: shown.width,
      height: shown.height,
      fit: BoxFit.fill,
      cacheWidth: columns,
      cacheHeight: rows,
      filterQuality: FilterQuality.none,
    );

    return _dimmed(image, config.coverDim * (1 - t));
  }
}
