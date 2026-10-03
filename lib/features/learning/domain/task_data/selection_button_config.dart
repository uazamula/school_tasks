import 'package:flutter/widgets.dart';

class SelectionButtonConfig {
  const SelectionButtonConfig({
    required this.fontSize,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.spacing,
    this.textScaler,
  });

  final double fontSize;
  final double buttonWidth;
  final double buttonHeight;
  final double spacing;

  /// Якщо null — використовується системний TextScaler Flutter.
  final TextScaler? textScaler;
}
