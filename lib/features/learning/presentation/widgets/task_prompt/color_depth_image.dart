import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Зображення з обмеженою глибиною кольору ([bits] біт на канал).
/// [bits] == null — оригінал. Кожен рівень рахується один раз і кешується.
class ColorDepthImage extends StatefulWidget {
  const ColorDepthImage({
    super.key,
    required this.assetPath,
    required this.bits,
  }) : assert(bits == null || (bits >= 1 && bits <= 8));

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
  const _QuantizeJob(this.pixels, this.colors);

  final Uint8List pixels; // RGBA
  final int colors;
}

class _Box {
  const _Box(this.start, this.end, this.count);

  final int start; // діапазон у списку унікальних кольорів
  final int end;
  final int count; // кількість пікселів
}

Future<ui.Image> _quantize(
    Uint8List src,
    int width,
    int height,
    int bits,
    ) async {
  // Важкий розрахунок виконується в окремому ізоляті.
  final out = await compute(_medianCut, _QuantizeJob(src, 1 << bits));

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

/// Median cut: пікселі групуються в гістограму 32×32×32, яка ділиться
/// на `job.colors` областей; колір області — середнє зважене.
Uint8List _medianCut(_QuantizeJob job) {
  final src = job.pixels;

  final counts = Int32List(32768);
  final sumR = Float64List(32768);
  final sumG = Float64List(32768);
  final sumB = Float64List(32768);
  var total = 0;

  for (var i = 0; i < src.length; i += 4) {
    if (src[i + 3] == 0) continue; // повністю прозорі пікселі пропускаємо
    final key =
    ((src[i] >> 3) << 10) | ((src[i + 1] >> 3) << 5) | (src[i + 2] >> 3);
    counts[key]++;
    sumR[key] += src[i];
    sumG[key] += src[i + 1];
    sumB[key] += src[i + 2];
    total++;
  }

  final entries = <int>[
    for (var k = 0; k < 32768; k++)
      if (counts[k] > 0) k,
  ];

  if (entries.isEmpty) return Uint8List.fromList(src);

  final boxes = <_Box>[_Box(0, entries.length, total)];

  while (boxes.length < job.colors) {
    // Ділимо область з найбільшою кількістю пікселів.
    var pick = -1;
    var best = 0;
    for (var i = 0; i < boxes.length; i++) {
      final box = boxes[i];
      if (box.end - box.start > 1 && box.count > best) {
        best = box.count;
        pick = i;
      }
    }
    if (pick == -1) break;

    final box = boxes[pick];

    // Канал з найбільшим розкидом значень.
    var minR = 31, maxR = 0, minG = 31, maxG = 0, minB = 31, maxB = 0;
    for (var e = box.start; e < box.end; e++) {
      final k = entries[e];
      final r = k >> 10, g = (k >> 5) & 31, b = k & 31;
      if (r < minR) minR = r;
      if (r > maxR) maxR = r;
      if (g < minG) minG = g;
      if (g > maxG) maxG = g;
      if (b < minB) minB = b;
      if (b > maxB) maxB = b;
    }
    final rangeR = maxR - minR, rangeG = maxG - minG, rangeB = maxB - minB;
    final channel = rangeR >= rangeG && rangeR >= rangeB
        ? 0
        : (rangeG >= rangeB ? 1 : 2);

    int chan(int k) =>
        channel == 0 ? k >> 10 : (channel == 1 ? (k >> 5) & 31 : k & 31);

    final sorted = entries.sublist(box.start, box.end)
      ..sort((a, b) => chan(a).compareTo(chan(b)));
    entries.setRange(box.start, box.end, sorted);

    // Розділення за медіаною по кількості пікселів.
    final half = box.count / 2;
    var acc = 0;
    var split = box.start + 1;
    for (var e = box.start; e < box.end - 1; e++) {
      acc += counts[entries[e]];
      split = e + 1;
      if (acc >= half) break;
    }

    boxes[pick] = _Box(box.start, split, acc);
    boxes.add(_Box(split, box.end, box.count - acc));
  }

  // Колір кожної області та таблиця «комірка гістограми → колір».
  final lut = Int32List(32768);
  for (final box in boxes) {
    var r = 0.0, g = 0.0, b = 0.0;
    for (var e = box.start; e < box.end; e++) {
      final k = entries[e];
      r += sumR[k];
      g += sumG[k];
      b += sumB[k];
    }
    final n = box.count;
    final packed =
    ((r / n).round() << 16) | ((g / n).round() << 8) | (b / n).round();
    for (var e = box.start; e < box.end; e++) {
      lut[entries[e]] = packed;
    }
  }

  final out = Uint8List(src.length);
  for (var i = 0; i < src.length; i += 4) {
    final a = src[i + 3];
    if (a == 0) {
      out[i] = src[i];
      out[i + 1] = src[i + 1];
      out[i + 2] = src[i + 2];
      out[i + 3] = 0;
      continue;
    }
    final key =
    ((src[i] >> 3) << 10) | ((src[i + 1] >> 3) << 5) | (src[i + 2] >> 3);
    final packed = lut[key];
    out[i] = (packed >> 16) & 255;
    out[i + 1] = (packed >> 8) & 255;
    out[i + 2] = packed & 255;
    out[i + 3] = a;
  }

  return out;
}