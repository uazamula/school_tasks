import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/selection_interaction.dart';
import 'package:school_tasks/features/learning/domain/tasks/selection_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';
import 'package:school_tasks/features/learning/presentation/widgets/choice_answer_button.dart';
import 'package:school_tasks/features/learning/presentation/widgets/image_answer_button.dart';
import 'package:school_tasks/features/learning/presentation/widgets/multi_choice_answer_button.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_prompt_widget.dart';

class SelectionTaskWidget<TOption, TAnswer, TSolution> extends StatefulWidget {
  const SelectionTaskWidget({
    super.key,
    required this.task,
    required this.result,
    required this.onTaskAnswered,
  });

  final SelectionTask<TOption, TAnswer, TSolution> task;
  final TaskResult<TAnswer, TSolution>? result;
  final ValueChanged<TaskResult<TAnswer, TSolution>> onTaskAnswered;

  @override
  State<SelectionTaskWidget<TOption, TAnswer, TSolution>> createState() =>
      _SelectionTaskWidgetState<TOption, TAnswer, TSolution>();
}

class _SelectionTaskWidgetState<TOption, TAnswer, TSolution>
    extends State<SelectionTaskWidget<TOption, TAnswer, TSolution>> {
  final Set<TOption> _selectedOptions = {};

  SelectionInteraction get _interaction =>
      widget.task.interaction as SelectionInteraction;

  bool get _isMultiple => _interaction.isMultiple;

  bool get _isAnswered => widget.result?.isAnswered ?? false;

  void _onOptionSelected(TOption option) {
    if (_isAnswered) {
      return;
    }

    if (_interaction.isSingle) {
      final answer = option as TAnswer;

      widget.onTaskAnswered(widget.task.checkAnswer(answer));

      return;
    }

    setState(() {
      if (_selectedOptions.contains(option)) {
        _selectedOptions.remove(option);
      } else {
        _selectedOptions.add(option);
      }
    });
  }

  void _confirmMultiple() {
    if (_isAnswered || _selectedOptions.isEmpty) {
      return;
    }

    final answer = _selectedOptions.toList() as TAnswer;

    widget.onTaskAnswered(widget.task.checkAnswer(answer));
  }

  TaskAnswerState _getAnswerState(TOption option) {
    final result = widget.result;

    if (result == null) {
      return TaskAnswerState.neutral;
    }

    final solution = result.solution?.value;

    if (_isMultiple && solution is List) {
      if (solution.contains(option)) {
        return TaskAnswerState.correct;
      }

      final selectedAnswer = result.selectedAnswer;

      if (selectedAnswer is List && selectedAnswer.contains(option)) {
        return TaskAnswerState.incorrect;
      }

      return TaskAnswerState.neutral;
    }

    if (solution == option) {
      return TaskAnswerState.correct;
    }

    if (result.selectedAnswer == option) {
      return TaskAnswerState.incorrect;
    }

    return TaskAnswerState.neutral;
  }

  Widget _buildOption(
    TOption option,
    TaskAnswerState state,
    bool isSelected,
    VoidCallback? onPressed, {
    double? imageSize,
  }) {
    if (option is ImageContent) {
      return ImageAnswerButton(
        answer: option,
        state: state,
        isSelected: isSelected,
        onPressed: onPressed,
        size: imageSize ?? 160,
      );
    }

    final answer = option.toString();

    if (_isMultiple) {
      return MultiChoiceAnswerButton(
        answer: answer,
        state: state,
        isSelected: isSelected,
        onPressed: onPressed,
      );
    }

    return ChoiceAnswerButton(
      answer: answer,
      state: state,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TaskPromptWidget(prompt: widget.task.prompt),

        const SizedBox(height: AppSpacing.xl),

        _buildOptions(),

        if (_isMultiple) ...[
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: _isAnswered || _selectedOptions.isEmpty
                ? null
                : _confirmMultiple,
            child: const Text('Підтвердити'),
          ),
        ],
      ],
    );
  }

  Widget _buildOptions() {
    final options = widget.task.options;

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = AppSpacing.md;

        // Текстові відповіді — одна кнопка в рядок.
        if (options.isNotEmpty && options.first is! ImageContent) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < options.length; i++) ...[
                if (i > 0) const SizedBox(height: spacing),
                _buildOption(
                  options[i],
                  _getAnswerState(options[i]),
                  _selectedOptions.contains(options[i]),
                  _isAnswered ? null : () => _onOptionSelected(options[i]),
                ),
              ],
            ],
          );
        }

        // Зображення — по два в рядок.
        final imageSize = (constraints.maxWidth - spacing) / 2;

        final rows = <Widget>[];

        for (var i = 0; i < options.length; i += 2) {
          final rowOptions = options.skip(i).take(2).toList();

          rows.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var j = 0; j < rowOptions.length; j++) ...[
                  if (j > 0) const SizedBox(width: spacing),
                  _buildOption(
                    rowOptions[j],
                    _getAnswerState(rowOptions[j]),
                    _selectedOptions.contains(rowOptions[j]),
                    _isAnswered ? null : () => _onOptionSelected(rowOptions[j]),
                    imageSize: imageSize,
                  ),
                ],
              ],
            ),
          );

          if (i + 2 < options.length) {
            rows.add(const SizedBox(height: spacing));
          }
        }

        return Column(mainAxisSize: MainAxisSize.min, children: rows);
      },
    );
  }
}
