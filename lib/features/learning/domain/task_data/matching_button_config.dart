import 'package:flutter/widgets.dart';

class MatchingButtonConfig {
  const MatchingButtonConfig({
    required this.fontSize,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.spacing,
    this.textScaler,
    this.lightBackgroundColor,
    this.darkBackgroundColor,
  });

  final double fontSize;
  final double buttonWidth;
  final double buttonHeight;
  final double spacing;

  /// Тло невибраної кнопки у світлій темі.
  final Color? lightBackgroundColor;

  /// Тло невибраної кнопки у темній темі.
  final Color? darkBackgroundColor;

  /// Якщо null — використовується системний TextScaler Flutter.
  final TextScaler? textScaler;
}
