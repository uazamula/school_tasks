import 'package:flutter/material.dart';

/// Показує дитячий діалог виходу. Повертає true, якщо треба вийти.
/// Тап поза діалогом означає «залишитись».
Future<bool> showKidsExitDialog(BuildContext context) async {
  final shouldExit = await showDialog<bool>(
    context: context,
    builder: (_) => const KidsExitDialog(),
  );

  return shouldExit == true;
}

/// Дві великі кнопки без тексту: «залишитись» і «вийти».
class KidsExitDialog extends StatelessWidget {
  const KidsExitDialog({super.key});

  // Піктограми в константах, щоб легко замінити.
  static const _stayIcon = '▶️';
  static const _exitIcon = '🚪➡️';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Менша й нейтральна кнопка виходу, щоб не натиснути випадково.
            FilledButton.tonal(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                minimumSize: const Size(80, 80),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(_exitIcon, style: TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 24),
            // Більша кольорова основна кнопка «залишитись».
            FilledButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: FilledButton.styleFrom(
                minimumSize: const Size(120, 120),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: const Text(_stayIcon, style: TextStyle(fontSize: 56)),
            ),
          ],
        ),
      ),
    );
  }
}
