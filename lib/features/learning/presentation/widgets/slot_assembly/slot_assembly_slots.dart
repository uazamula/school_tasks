import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/task_data/slot_assembly_ui_config.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly_task_widget.dart';

class SlotAssemblySlots extends StatelessWidget {
  const SlotAssemblySlots({
    super.key,
    required this.slots,
    required this.slotKeys,
    this.dragEnabled = false,
    this.occupiedSlots = const [],
    this.onOptionDropped,
    required this.uiConfig,
    this.hints = const [],
    this.showHints = false,
  });

  /// Поточний вміст слотів ([nothing] для порожнього).
  final List<String> slots;
  final List<GlobalKey> slotKeys;
  final bool dragEnabled;
  final List<bool> occupiedSlots;
  final void Function(int optionIndex, int slotIndex)? onOptionDropped;
  final SlotAssemblyUiConfig uiConfig;

  /// Правильний елемент для кожного слота (для підказки).
  final List<String> hints;

  /// Чи показувати підказки блідим кольором у порожніх слотах.
  final bool showHints;

  /// Кольори тексту слота: яскравий (доставлено) і блідий (підказка).
  static const double _hintAlpha = 0.22;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final slotColor = Color.alphaBlend(
      theme.brightness == Brightness.light
          ? Colors.black.withValues(alpha: 0.06)
          : Colors.white.withValues(alpha: 0.08),
      colorScheme.surface,
    );

    final brightColor =
        theme.textTheme.titleLarge?.color ?? colorScheme.onSurface;
    final paleColor = colorScheme.onSurface.withValues(alpha: _hintAlpha);

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (var i = 0; i < slots.length; i++)
          DragTarget<int>(
            onWillAcceptWithDetails: (details) {
              return dragEnabled &&
                  i < occupiedSlots.length &&
                  !occupiedSlots[i];
            },
            onAcceptWithDetails: (details) {
              onOptionDropped?.call(details.data, i);
            },
            builder: (context, candidateData, rejectedData) {
              final isOccupied = i < occupiedSlots.length && occupiedSlots[i];
              final hint = showHints && i < hints.length ? hints[i] : null;

              // Підказка і доставлений елемент однакові за змістом,
              // тому відрізняються лише кольором — він плавно змінюється.
              final shownText = isOccupied ? slots[i] : (hint ?? slots[i]);
              // З підказками розмір слота береться за правильним елементом,
              // щоб слот не «стрибав» після доставки.
              final sizingText = hint ?? slots[i];

              final textStyle =
                  (theme.textTheme.titleLarge ?? const TextStyle()).copyWith(
                    fontSize: 38,
                    color: isOccupied || hint == null ? brightColor : paleColor,
                  );

              return Container(
                key: slotKeys[i],
                constraints: BoxConstraints(
                  minWidth:
                      uiConfig.slotWidthPerCharacter *
                      (sizingText != nothing
                          ? effectiveTextLength(sizingText)
                          : 2.0),
                  minHeight: uiConfig.slotHeight,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: slotColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: AnimatedDefaultTextStyle(
                  style: textStyle,
                  duration: const Duration(milliseconds: 200),
                  child: Text(shownText),
                ),
              );
            },
          ),
      ],
    );
  }

  double effectiveTextLength(String text) {
    return text.runes.fold<double>(0, (length, rune) {
      final isSubscriptDigit = rune >= 0x2080 && rune <= 0x2089;
      return length + (isSubscriptDigit ? 0.5 : 1.0);
    });
  }
}
