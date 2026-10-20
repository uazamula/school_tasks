import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_linked_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/math_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/target_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/presentation/widgets/math_content_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_audio_widget.dart';

class TaskPromptWidget extends StatelessWidget {
   const TaskPromptWidget({
    super.key,
    required this.prompt,
    this.scrollable = false,
     this.targetProgress = 0,
  });

  final TaskPrompt prompt;
  final bool scrollable;
   /// Кількість правильно заповнених слотів.
   final int targetProgress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: colorScheme.onSurfaceVariant,
    );
    if (scrollable) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildScrollableContent(context, prompt.content, textStyle),
          if (prompt.target != null) ...[
            const SizedBox(height: AppSpacing.md),
            _buildTargetContent(context, prompt.target!, textStyle),
          ],
        ],
      );
    }
    debugPrint('TaskPrompt target: ${prompt.target?.target}');
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        final firstVisualIndex = prompt.content.indexWhere(_isVisual);

        // Увесь prompt є невізуальним.
        if (firstVisualIndex == -1) {
          return SizedBox(
            width: maxWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNonVisualContent(
                  context,
                  prompt.content,
                  textStyle,
                ),
                if (prompt.target != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: maxWidth,
                    height: 120,
                    child: _buildTargetContent(
                      context,
                      prompt.target!,
                      textStyle,
                    ),
                  ),
                ],
              ],
            ),
          );
        }

        final nonVisualContent = prompt.content.sublist(0, firstVisualIndex);
        final scalableContent = prompt.content.sublist(firstVisualIndex);

        return SizedBox(
          width: maxWidth,
          child: Column(
            children: [
              if (nonVisualContent.isNotEmpty)
                _buildNonVisualContent(
                  context,
                  nonVisualContent,
                  textStyle,
                ),

              if (nonVisualContent.isNotEmpty)
                const SizedBox(height: AppSpacing.md),

              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _buildScalableContent(
                        context,
                        scalableContent,
                        textStyle,
                      ),
                    ),

                    if (prompt.target != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 120,
                        width: maxWidth,
                        child: _buildTargetContent(
                          context,
                          prompt.target!,
                          textStyle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isVisual(TaskContent content) {
    if (content is ImageContent ||
        content is GridContent ||
        content is EmojiContent) {
      return true;
    }

    if (content is AudioLinkedContent) {
      return _isVisual(content.content);
    }

    return false;
  }

  Widget _buildNonVisualContent(
    BuildContext context,
    List<TaskContent> content,
    TextStyle? textStyle,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final item in content) ...[
          _buildContent(context, item, textStyle, fullWidthText: true),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }

  Widget _buildScalableContent(
    BuildContext context,
    List<TaskContent> content,
    TextStyle? textStyle,
  ) {
    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final item in content) ...[
              _buildContent(context, item, textStyle, fullWidthText: false),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    TaskContent content,
    TextStyle? textStyle, {
    bool fullWidthText = false,
  }) {
    if (content is TextContent) {
      final text = Text(
        content.text,
        style: textStyle,
        textAlign: TextAlign.center,
        softWrap: true,
      );

      if (fullWidthText) {
        return SizedBox(width: double.infinity, child: text);
      }

      return text;
    }

    if (content is AudioContent) {
      return TaskAudioWidget(content: content);
    }

    if (content is AudioLinkedContent) {
      return TaskAudioWidget(
        content: content.audio,
        interactive: true,
        showIcon: false,
        child: _buildContent(
          context,
          content.content,
          textStyle,
          fullWidthText: fullWidthText,
        ),
      );
    }

    if (content is ImageContent) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        child: Image.asset(content.imagePath, fit: BoxFit.contain),
      );
    }

    if (content is MathContent) {
      return MathContentWidget(
        expression: content.expression,
        style: textStyle,
      );
    }

    if (content is GridContent) {
      return _buildGrid(content);
    }

    if (content is EmojiContent) {
      return Text(
        content.emoji,
        textAlign: TextAlign.center,
        style: textStyle?.copyWith(fontSize: 64),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildGrid(GridContent content) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        const spacing = AppSpacing.md;

        final horizontalSpacing = spacing * (content.columns - 1);

        final availableWidth = maxWidth - horizontalSpacing;

        if (availableWidth <= 0) {
          return const SizedBox.shrink();
        }

        final cellSize = availableWidth / content.columns;

        final width = cellSize * content.columns + horizontalSpacing;

        final height = cellSize * content.rows + spacing * (content.rows - 1);

        return SizedBox(
          width: width,
          height: height,
          child: GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: content.columns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: 1,
            ),
            itemCount: content.rows * content.columns,
            itemBuilder: (context, index) {
              return SizedBox(
                width: cellSize,
                height: cellSize,
                child: _buildContent(context, content.item, null),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildScrollableContent(
    BuildContext context,
    List<TaskContent> content,
    TextStyle? textStyle,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final item in content) ...[
          _buildContent(context, item, textStyle, fullWidthText: true),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }

   Widget _buildTargetContent(
       BuildContext context,
       TargetContent target,
       TextStyle? textStyle,
       ) {
     final effect = target.effect;

     if (effect == null || target.target is! ImageContent) {
       return _buildContent(
         context,
         target.target,
         textStyle,
         fullWidthText: true,
       );
     }

     switch (effect.type) {
       case TargetEffectType.saturation:
         final progress = (targetProgress / effect.steps)
             .clamp(0.0, 1.0)
             .toDouble();

         final image = _buildContent(
           context,
           target.target,
           textStyle,
           fullWidthText: true,
         );

         if (progress >= 1.0) {
           return image;
         }

         return ColorFiltered(
           colorFilter: ColorFilter.matrix(
             _saturationMatrix(progress),
           ),
           child: image,
         );
     }
   }

   List<double> _saturationMatrix(double saturation) {
     const red = 0.2126;
     const green = 0.7152;
     const blue = 0.0722;

     final inverse = 1 - saturation;

     final r = inverse * red;
     final g = inverse * green;
     final b = inverse * blue;

     return [
       r + saturation, g, b, 0, 0,
       r, g + saturation, b, 0, 0,
       r, g, b + saturation, 0, 0,
       0, 0, 0, 1, 0,
     ];
   }
}
