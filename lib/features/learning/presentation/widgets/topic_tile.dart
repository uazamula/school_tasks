import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/core/theme/app_text_styles.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/presentation/widgets/topic_title_content.dart';

/// «Піднята» плитка теми: результат зліва, назва справа.
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
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final kids = widget.kidsMode;

    final height = kids ? 120.0 : 94.0;
    final resultWidth = kids ? 88.0 : 56.0;
    final radius = BorderRadius.circular(kids ? 28 : 14);

    // Натиснута плитка «просідає»: тінь стає меншою.
    final shadow = BoxShadow(
      color: colors.shadow.withValues(alpha: kids ? 0.22 : 0.15),
      blurRadius: _pressed ? 4 : (kids ? 14 : 8),
      offset: Offset(0, _pressed ? 2 : (kids ? 7 : 4)),
    );

    return AnimatedScale(
      scale: _pressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 120),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: height,
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colors.surfaceContainerLowest,
              colors.surfaceContainerHigh,
            ],
          ),
          border: Border.all(color: colors.outlineVariant, width: kids ? 2 : 1),
          boxShadow: [shadow],
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
