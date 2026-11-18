import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';

/// Ряд елементів назви теми. Висота комірок дорівнює доступній висоті,
/// а якщо ряд не вміщується за шириною, він пропорційно зменшується.
/// Прокрутки немає.
class TopicTitleContent extends StatelessWidget {
  const TopicTitleContent({super.key, required this.items});

  final List<TaskContent> items;

  // Базовий розмір шрифту, який потім масштабує FittedBox.
  static const double _baseFont = 100;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cell = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : 64.0;

        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) SizedBox(width: cell * 0.12),
                _buildItem(items[i], cell, primary),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem(TaskContent item, double cell, Color primary) {
    if (item is TextContent) {
      // Буква: А, а або Аа. «Аа» ширше за одну букву.
      final width = cell * (item.text.length > 1 ? 1.35 : 0.85);

      return SizedBox(
        width: width,
        height: cell,
        child: FittedBox(
          child: Text(
            item.text,
            style: TextStyle(
              fontSize: _baseFont,
              fontWeight: FontWeight.w800,
              height: 1,
              color: primary,
              shadows: [
                Shadow(
                  color: primary.withValues(alpha: 0.25),
                  offset: const Offset(0, 4),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (item is EmojiContent) {
      return SizedBox.square(
        dimension: cell,
        child: FittedBox(
          child: Text(
            item.emoji,
            style: const TextStyle(fontSize: _baseFont, height: 1),
          ),
        ),
      );
    }

    if (item is ImageContent) {
      return SizedBox.square(
        dimension: cell,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Image.asset(
            item.imagePath,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) =>
                const Icon(Icons.image_not_supported_outlined),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
