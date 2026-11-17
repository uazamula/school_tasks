import 'package:flutter/material.dart';

/// Верхня смужка дитячого режиму: одна велика кнопка зліва.
/// На головній це шестерня (налаштування), на інших екранах це «додому».
class KidsShellBar extends StatelessWidget {
  const KidsShellBar({
    super.key,
    required this.isHome,
    required this.onPressed,
  });

  final bool isHome;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: IconButton.filledTonal(
          onPressed: onPressed,
          iconSize: 28,
          padding: const EdgeInsets.all(2),
          tooltip: isHome ? 'Налаштування' : 'Додому',
          icon: Icon(isHome ? Icons.settings : Icons.home_rounded),
        ),
      ),
    );
  }
}
