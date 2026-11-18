import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/core/theme/app_text_styles.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/presentation/widgets/topic_title_content.dart';

/// «Піднята» плитка теми: результат зліва, назва справа.
/// Об'єм дає товста нижня межа, яка при натисканні зникає.
class TopicTile extends StatefulWidget {
  const TopicTile({
    super.key,
    required this.onTap,
    required this.result,
    required this.fallbackTitle,
    this.titleContent = const [],
    this.kidsMode = false,
  });

  final VoidCallback? onTap;
  final Widget result;
  final String fallbackTitle;
  final List<TaskContent> titleContent;
  final bool kidsMode;

  @override
  State<TopicTile> createState() => _TopicTileState();
}

class _TopicTileState extends State<TopicTile> {
  static const _pressDuration = Duration(milliseconds: 90);

  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final kids = widget.kidsMode;

    final height = kids ? 120.0 : 94.0;
    final depth = kids ? 8.0 : 5.0; // Висота нижньої межі.
    final resultWidth = kids ? 88.0 : 56.0;
    final radius = BorderRadius.circular(kids ? 28 : 14);

    // Основа темніша за межу лицьової частини.
    final edgeColor = Color.lerp(colors.outlineVariant, colors.shadow, 0.35)!;

    final face = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.surfaceContainerLowest, colors.surfaceContainerHigh],
        ),
        border: Border.all(color: colors.outlineVariant, width: kids ? 2 : 1),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) => _setPressed(true),
            onTapUp: (_) => _setPressed(false),
            onTapCancel: () => _setPressed(false),
            child: Padding(
              padding: EdgeInsets.all(kids ? AppSpacing.md : AppSpacing.sm),
              child: Row(
                children: [
                  // Результат на легкому підкладеному фоні.
                  Container(
                    width: resultWidth,
                    decoration: BoxDecoration(
                      color: colors.primaryContainer.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(kids ? 20 : 10),
                    ),
                    child: Center(child: widget.result),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: _buildTitle()),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          // Основа: видно лише її нижню смужку.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(color: edgeColor, borderRadius: radius),
            ),
          ),
          // Лицьова частина опускається на висоту межі при натисканні.
          AnimatedPositioned(
            duration: _pressDuration,
            left: 0,
            right: 0,
            top: _pressed ? depth : 0,
            bottom: _pressed ? 0 : depth,
            child: face,
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    if (widget.titleContent.isNotEmpty) {
      return TopicTitleContent(items: widget.titleContent);
    }

    // Запасний варіант: текст без прокрутки, максимум три рядки.
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        widget.fallbackTitle,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: widget.kidsMode ? AppTextStyles.title : AppTextStyles.body,
      ),
    );
  }
}
