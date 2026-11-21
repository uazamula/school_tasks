import 'package:flutter/material.dart';

/// Показує дитячий діалог виходу. Повертає true, якщо треба вийти.
/// Хрестик і тап поза діалогом означають «залишитись».
Future<bool> showKidsExitDialog(BuildContext context) async {
  final shouldExit = await showDialog<bool>(
    context: context,
    builder: (_) => const KidsExitDialog(),
  );

  return shouldExit == true;
}

/// Одна велика кнопка виходу та хрестик у куті.
class KidsExitDialog extends StatelessWidget {
  const KidsExitDialog({super.key});

  static const _exitImage = 'assets/images/exit.png';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
            child: FilledButton.tonal(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                minimumSize: const Size(120, 120),
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: Image.asset(
                _exitImage,
                width: 88,
                height: 88,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.directions_run, size: 72),
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(false),
              icon: const Icon(Icons.close_rounded, size: 32),
              tooltip: 'Залишитись',
            ),
          ),
        ],
      ),
    );
  }
}
