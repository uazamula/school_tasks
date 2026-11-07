import 'package:flutter/widgets.dart';

class MemoryFaceStyle {
  const MemoryFaceStyle({
    this.lightBackgroundColor,
    this.darkBackgroundColor,
    this.textStyle,
    this.textScaler,
  });

  final Color? lightBackgroundColor;
  final Color? darkBackgroundColor;
  final TextStyle? textStyle;
  final TextScaler? textScaler;
}

/// Закрита сторона картки B.
class MemoryCoverStyle {
  const MemoryCoverStyle({
    this.face = const MemoryFaceStyle(),
    this.text,
    this.imagePath,
  });

  final MemoryFaceStyle face;
  final String? text;
  final String? imagePath;
}

class MemoryCardStyleConfig {
  const MemoryCardStyleConfig({
    this.cover = const MemoryCoverStyle(),
    this.hiddenFace = const MemoryFaceStyle(),
    this.front = const MemoryFaceStyle(),
    this.back = const MemoryFaceStyle(),
  });

  /// B закрита.
  final MemoryCoverStyle cover;

  /// B відкрита (прихований вміст).
  final MemoryFaceStyle hiddenFace;

  /// A видима сторона.
  final MemoryFaceStyle front;

  /// A зворотний бік.
  final MemoryFaceStyle back;
}
