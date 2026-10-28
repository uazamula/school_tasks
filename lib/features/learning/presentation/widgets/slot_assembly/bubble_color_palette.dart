import 'dart:math' as math;

import 'package:flutter/material.dart';

class BubbleColorPalette {
  static const List<Color> _colors = [
    Color(0xFF2879C7),
    Color(0xFF159B88),
    Color(0xFF8054C7),
    Color(0xFFD66B35),
    Color(0xFFC74770),
    Color(0xFF647D35),
  ];

  final Map<int, Color> _colorsByOption = {};

  Color colorFor(int optionIndex) {
    return _colorsByOption.putIfAbsent(
      optionIndex,
      () => _colors[math.Random().nextInt(_colors.length)],
    );
  }
}
