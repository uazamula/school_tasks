import 'package:flutter/material.dart';

/// Кнопка дитячого режиму: на головній шестерня (налаштування),
/// на інших екранах «додому». Розміщується поверх контенту (Stack).
class KidsShellBar extends StatelessWidget {
  const KidsShellBar({
    super.key,
    required this.isHome,
    required this.onPressed,
  });

  final bool isHome;
  final VoidCallback onPressed;

  static const double _button = 26;
  static const double _margin = 4;

  /// Висота смужки, яку шелл резервує зверху під кнопку.
  static const double height = _button + _margin * 2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_margin),
      child: IconButton.filledTonal(
        onPressed: onPressed,
        iconSize: 28,
        padding: const EdgeInsets.all(8),
        style: IconButton.styleFrom(
          minimumSize: const Size(_button, _button),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        tooltip: isHome ? 'Налаштування' : 'Додому',
        icon: Icon(isHome ? Icons.settings : Icons.home_rounded),
      ),
    );
  }
}
