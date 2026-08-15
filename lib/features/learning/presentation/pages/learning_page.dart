import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/learning_task.dart';
import 'package:school_tasks/features/learning/domain/learning_task_generator.dart';
import 'package:school_tasks/features/learning/presentation/widgets/choice_task_widget.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_scaffold.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key, required this.topicId});

  final String topicId;

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  late final LearningTask _task;
  final LearningTaskGenerator _generator = LearningTaskGenerator();

  int? _selectedAnswer;

  @override
  void initState() {
    super.initState();

    _task = _generator.generateAdditionWithin10();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChoiceTaskWidget(task: _task, onAnswerSelected: _onAnswerSelected),

            if (_selectedAnswer != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: Text(
                  _task.isCorrect(_selectedAnswer!)
                      ? 'Правильно!'
                      : 'Неправильно!',
                  style: AppTextStyles.title,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onAnswerSelected(int answer) {
    setState(() {
      _selectedAnswer = answer;
    });
  }
}
