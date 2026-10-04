import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_linked_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/selection_interaction.dart';
import 'package:school_tasks/features/learning/domain/tasks/selection_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';
import 'package:school_tasks/features/learning/presentation/widgets/audio_answer_button.dart';
import 'package:school_tasks/features/learning/presentation/widgets/selection/choice_answer_button.dart';
import 'package:school_tasks/features/learning/presentation/widgets/selection/multi_choice_answer_button.dart';
import 'package:school_tasks/features/learning/presentation/widgets/selection/visual_answer_button.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_audio_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_interaction_layout.dart';

class SelectionTaskWidget<TOption, TAnswer, TSolution> extends StatefulWidget {
  const SelectionTaskWidget({
    super.key,
    required this.task,
    required this.result,
    required this.onTaskAnswered,
    this.interactionScrollable = false,
    required this.feedbackEnabled,
  });

  final SelectionTask<TOption, TAnswer, TSolution> task;
  final TaskResult<TAnswer, TSolution>? result;
  final ValueChanged<TaskResult<TAnswer, TSolution>> onTaskAnswered;
  final bool interactionScrollable;
  final bool feedbackEnabled;

  @override
  State<SelectionTaskWidget<TOption, TAnswer, TSolution>> createState() =>
      _SelectionTaskWidgetState<TOption, TAnswer, TSolution>();
}

class _SelectionTaskWidgetState<TOption, TAnswer, TSolution>
    extends State<SelectionTaskWidget<TOption, TAnswer, TSolution>> {
  final Set<TOption> _selectedOptions = {};
  TaskContent? _activeAudioOption;

  SelectionInteraction get _interaction =>
      widget.task.interaction as SelectionInteraction;

  bool get _isMultiple => _interaction.isMultiple;

  bool get _requiresConfirmation => _interaction.requiresConfirmation;

  bool get _isAnswered => widget.result?.isAnswered ?? false;

  @override
  void didUpdateWidget(
    covariant SelectionTaskWidget<TOption, TAnswer, TSolution> oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.task != widget.task) {
      _selectedOptions.clear();
      _activeAudioOption = null;
    }
  }

  void _onOptionSelected(TOption option) {
    if (_isAnswered) return;
    if (option is AudioLinkedContent) {
      setState(() {
        _activeAudioOption = option;
      });
    } else if (_activeAudioOption != null) {
      setState(() {
        _activeAudioOption = null;
      });
    }

    if (option is AudioContent) {
      _onAudioOptionSelected(option as TaskContent);
      return;
    }

    if (!_isMultiple && !_requiresConfirmation) {
      final answer = option as TAnswer;
      widget.onTaskAnswered(widget.task.checkAnswer(answer));
      return;
    }

    if (!_isMultiple) {
      setState(() {
        _selectedOptions
          ..clear()
          ..add(option);
      });
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

  void _confirmSelection() {
    if (_isAnswered || _selectedOptions.isEmpty) return;

    final answer = _isMultiple
        ? _selectedOptions.toList() as TAnswer
        : _selectedOptions.first as TAnswer;

    widget.onTaskAnswered(widget.task.checkAnswer(answer));
  }

  TaskAnswerState _getAnswerState(TOption option) {
    if (!widget.feedbackEnabled) {
      return TaskAnswerState.neutral;
    }

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
    if (option is AudioLinkedContent) {
      final linkedContent = option.content;

      Widget answerButton;

      if (linkedContent is ImageContent) {
        answerButton = VisualAnswerButton(
          state: state,
          isSelected: isSelected,
          onPressed: onPressed,
          size: imageSize ?? 160,
          child: Image.asset(linkedContent.imagePath, fit: BoxFit.contain),
        );
      } else if (linkedContent is EmojiContent) {
        answerButton = VisualAnswerButton(
          state: state,
          isSelected: isSelected,
          onPressed: onPressed,
          size: imageSize ?? 160,
          child: Text(
            linkedContent.emoji,
            style: const TextStyle(fontSize: 300),
          ),
        );
      } else {
        final answer = linkedContent.toString();

        if (_isMultiple) {
          answerButton = MultiChoiceAnswerButton(
            answer: answer,
            state: state,
            isSelected: isSelected,
            onPressed: onPressed,
            buttonConfig: widget.task.buttonConfig,
          );
        } else {
          answerButton = ChoiceAnswerButton(
            answer: answer,
            state: state,
            isSelected: isSelected,
            onPressed: onPressed,
            buttonConfig: widget.task.buttonConfig,
          );
        }
      }

      return TaskAudioWidget(
        content: option.audio,
        isActive: _activeAudioOption == option,
        interactive: false,
        showIcon: false,
        child: answerButton,
      );
    }

    if (option is ImageContent) {
      return VisualAnswerButton(
        state: state,
        isSelected: isSelected,
        onPressed: onPressed,
        size: imageSize ?? 160,
        child: Image.asset(option.imagePath, fit: BoxFit.contain),
      );
    }

    if (option is EmojiContent) {
      return VisualAnswerButton(
        state: state,
        isSelected: isSelected,
        onPressed: onPressed,
        size: imageSize ?? 160,
        child: Text(option.emoji, style: const TextStyle(fontSize: 300)),
      );
    }

    if (option is AudioContent) {
      return AudioAnswerButton(
        answer: option,
        state: state,
        isSelected: isSelected,
        isActive: _activeAudioOption == option,
        onPressed: onPressed,
      );
    }

    final answer = option.toString();

    if (_isMultiple) {
      return MultiChoiceAnswerButton(
        answer: answer,
        state: state,
        isSelected: isSelected,
        onPressed: onPressed,
        buttonConfig: widget.task.buttonConfig,
      );
    }

    return ChoiceAnswerButton(
      answer: answer,
      state: state,
      isSelected: isSelected,
      onPressed: onPressed,
      buttonConfig: widget.task.buttonConfig,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TaskInteractionLayout(
      scrollable: widget.interactionScrollable,
      content: _buildOptions(),
      confirmation: _requiresConfirmation
          ? FilledButton(
              onPressed: _isAnswered || _selectedOptions.isEmpty
                  ? null
                  : _confirmSelection,
              child: const Text('Підтвердити'),
            )
          : null,
    );
  }

  Widget _buildOptions() {
    final options = widget.task.options;

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = AppSpacing.md;
        final isVisualOptions =
            options.isNotEmpty &&
            (options.first is ImageContent || options.first is EmojiContent);

        if (!isVisualOptions) {
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

        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : (160.0 * 2 + spacing);

        final imageSize = (availableWidth - spacing) / 2;

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

  void _onAudioOptionSelected(TaskContent option) {
    final typedOption = option as TOption;

    setState(() {
      if (_activeAudioOption == option) {
        _activeAudioOption = null;
        _selectedOptions.remove(typedOption);
        return;
      }

      _activeAudioOption = option;

      _selectedOptions
        ..clear()
        ..add(typedOption);
    });
  }
}
