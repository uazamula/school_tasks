import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_prompt/retro_palettes.dart';

/// Зображення з обмеженою глибиною кольору ([bits] біт на канал).
/// [bits] == null — оригінал. Кожен рівень рахується один раз і кешується.
class ColorDepthImage extends StatefulWidget {
  const ColorDepthImage({
    super.key,
    required this.assetPath,
    required this.bits,
  }) : assert(
  bits == null || bits == 1 || bits == 2 || bits == 4 || bits == 8,
  );

  final String assetPath;
  final int? bits;

  @override
  State<ColorDepthImage> createState() => _ColorDepthImageState();
}

class _ColorDepthImageState extends State<ColorDepthImage> {
  ui.Image? _original;
  Uint8List? _pixels;
  final Map<int, ui.Image> _cache = {};
  ui.Image? _displayed;
  bool _failed = false;
  int _token = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_update());
  }

  @override
  void didUpdateWidget(ColorDepthImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final pathChanged = oldWidget.assetPath != widget.assetPath;
    if (pathChanged) _releaseImages();
    if (pathChanged || oldWidget.bits != widget.bits) {
      unawaited(_update());
    }
  }

  @override
  void dispose() {
    _token++;
    _releaseImages();
    super.dispose();
  }

  void _releaseImages() {
    _displayed = null;
    _failed = false;
    _original?.dispose();
    _original = null;
    _pixels = null;
    for (final image in _cache.values) {
      image.dispose();
    }
    _cache.clear();
  }

  Future<void> _update() async {
    final token = ++_token;
    final bits = widget.bits;

    try {
      if (_pixels == null) {
        final data = await rootBundle.load(widget.assetPath);
        final codec = await ui.instantiateImageCodec(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        );
        final frame = await codec.getNextFrame();
        codec.dispose();

        final image = frame.image;
        final bytes = await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );

        if (!mounted || token != _token || bytes == null) {
          image.dispose();
          return;
        }

        _original = image;
        _pixels = bytes.buffer.asUint8List(
          bytes.offsetInBytes,
          bytes.lengthInBytes,
        );
      }

      ui.Image? target;

      if (bits == null) {
        target = _original;
      } else {
        target = _cache[bits];

        if (target == null) {
          final created = await _quantize(
            _pixels!,
            _original!.width,
            _original!.height,
            bits,
          );

          if (!mounted || token != _token) {
            created.dispose();
            return;
          }

          _cache[bits] = created;
          target = created;
        }
      }

      if (!mounted || token != _token) return;
      setState(() => _displayed = target);
    } catch (error) {
      debugPrint('ColorDepthImage failed: $error');
      if (mounted && token == _token) setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) return Image.asset(widget.assetPath, fit: BoxFit.contain);

    final image = _displayed;
    if (image == null) return const SizedBox.shrink();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: RawImage(
        key: ValueKey<ui.Image>(image),
        image: image,
        fit: BoxFit.contain,
      ),
    );
  }
}
class _QuantizeJob {
  const _QuantizeJob(this.pixels, this.width, this.bits);

  final Uint8List pixels; // RGBA
  final int width;
  final int bits;
}

Future<ui.Image> _quantize(
    Uint8List src,
    int width,
    int height,
    int bits,
    ) async {
  // Розрахунок виконується в окремому ізоляті.
  final out = await compute(_ditherToPalette, _QuantizeJob(src, width, bits));

  final completer = Completer<ui.Image>();
  ui.decodeImageFromPixels(
    out,
    width,
    height,
    ui.PixelFormat.rgba8888,
    completer.complete,
  );
  return completer.future;
}

const _bayer4 = [0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5];

/// Амплітуда дизерингу: приблизно крок між сусідніми рівнями палітри.
double _spreadFor(int bits) => switch (bits) {
  1 => 255,
  2 => 200,
  4 => 85,
  _ => 51,
};

Uint8List _ditherToPalette(_QuantizeJob job) {
  final palette = RetroPalettes.forBits(job.bits)!;
  final spread = _spreadFor(job.bits);
  final src = job.pixels;
  final width = job.width;
  final out = Uint8List(src.length);

  // Кеш «комірка 5×5×5 біт → індекс найближчого кольору палітри».
  final lut = Int32List(32768)..fillRange(0, 32768, -1);

  for (var i = 0, p = 0; i < src.length; i += 4, p++) {
    final a = src[i + 3];

    if (a == 0) {
      out[i] = src[i];
      out[i + 1] = src[i + 1];
      out[i + 2] = src[i + 2];
      out[i + 3] = 0;
      continue;
    }

    final x = p % width;
    final y = p ~/ width;
    final threshold = (_bayer4[(y & 3) * 4 + (x & 3)] + 0.5) / 16 - 0.5;
    final offset = threshold * spread;

    final r = (src[i] + offset).round().clamp(0, 255).toInt();
    final g = (src[i + 1] + offset).round().clamp(0, 255).toInt();
    final b = (src[i + 2] + offset).round().clamp(0, 255).toInt();

    final key = ((r >> 3) << 10) | ((g >> 3) << 5) | (b >> 3);
    var index = lut[key];

    if (index < 0) {
      // Центр комірки гістограми.
      index = _nearest(
        palette,
        ((r >> 3) << 3) | 4,
        ((g >> 3) << 3) | 4,
        ((b >> 3) << 3) | 4,
      );
      lut[key] = index;
    }

    final color = palette[index];
    out[i] = (color >> 16) & 255;
    out[i + 1] = (color >> 8) & 255;
    out[i + 2] = color & 255;
    out[i + 3] = a;
  }

  return out;
}

/// Найближчий колір палітри за відстанню «redmean».
int _nearest(List<int> palette, int r, int g, int b) {
  var best = 0;
  var bestDistance = double.infinity;

  for (var k = 0; k < palette.length; k++) {
    final c = palette[k];
    final pr = (c >> 16) & 255;
    final pg = (c >> 8) & 255;
    final pb = c & 255;

    final rMean = (r + pr) / 2;
    final dr = r - pr;
    final dg = g - pg;
    final db = b - pb;

    final distance =
        (2 + rMean / 256) * dr * dr +
            4 * dg * dg +
            (2 + (255 - rMean) / 256) * db * db;

    if (distance < bestDistance) {
      bestDistance = distance;
      best = k;
    }
  }

  return best;
}