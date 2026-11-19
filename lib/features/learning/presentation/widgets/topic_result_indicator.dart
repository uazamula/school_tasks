import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:school_tasks/core/config/app_config.dart';
import 'package:school_tasks/core/formatters/duration_formatter.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_attempt_snapshot.dart';
import 'package:school_tasks/features/learning/domain/evaluation/grade_scale.dart';
import 'package:school_tasks/features/learning/domain/evaluation/topic_result_attempt.dart';
import 'package:school_tasks/features/learning/domain/evaluation/topic_result_display.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';
import 'package:school_tasks/features/learning/domain/topic_result_kind.dart';
import 'package:school_tasks/features/learning/presentation/widgets/grade_mark.dart';
import 'package:school_tasks/features/learning/presentation/widgets/visual_grade_scale_widget.dart';
import 'package:school_tasks/features/learning/providers/grade_scale_controller.dart';
import 'package:school_tasks/features/learning/providers/topic_result_attempt_controller.dart';
import 'package:school_tasks/features/learning/providers/topic_result_display_controller.dart';

class TopicResultIndicator extends ConsumerWidget {
  const TopicResultIndicator({
    super.key,
    required this.result,
    this.kidsMode = false,
  });

  final TopicResult? result;

  /// Дитячий режим: завжди візуальна шкала, без часу.
  final bool kidsMode;

  static const double _gradeFontSize = 20;
  static const double _durationFontSize = 12;

  static const double _visualSizeGradeOnly = 56;
  static const double _visualSizeGradeAndDuration = 46;
  static const double _visualSizeKids = 72;

  /// Порожній стан: зірочка для дітей, прочерк для дорослих.
  Widget _buildEmpty() {
    return kidsMode
        ? const Icon(Icons.star_border_rounded, size: 40)
        : const Text('-');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stored = result;

    if (stored == null) {
      return _buildEmpty();
    }

    final attemptAsync = ref.watch(topicResultAttemptControllerProvider);
    final gradeScaleAsync = ref.watch(gradeScaleControllerProvider);
    final displayAsync = ref.watch(topicResultDisplayControllerProvider);

    if (attemptAsync.isLoading ||
        gradeScaleAsync.isLoading ||
        displayAsync.isLoading ||
        attemptAsync.hasError ||
        gradeScaleAsync.hasError ||
        displayAsync.hasError) {
      return _buildEmpty();
    }

    // Вибір користувача або значення за замовчуванням для режиму.
    final attemptKind =
        attemptAsync.value ??
        (kidsMode
            ? AppConfig.kidsResultAttemptDefault
            : AppConfig.resultAttemptDefault);

    final TopicAttemptSnapshot? snapshot =
        attemptKind == TopicResultAttempt.best
        ? stored.bestAttempt
        : stored.currentAttempt;

    // Найкращої зарахованої спроби ще немає.
    if (snapshot == null) {
      return _buildEmpty();
    }

    final gradeScale = gradeScaleAsync.value!;

    Widget main(GradeScale scale, double visualSize) =>
        snapshot.kind == TopicResultKind.streak
        ? _buildStreak(snapshot.streak ?? 0)
        : _buildGrade(scale, snapshot, visualSize: visualSize);

    if (kidsMode) {
      return main(gradeScale.forKids, _visualSizeKids);
    }

    final display = displayAsync.value!;

    // Тривалість з тієї самої спроби, що й оцінка.
    final duration = DurationFormatter.formatShort(context, snapshot.duration);

    return switch (display) {
      TopicResultDisplay.grade => main(gradeScale, _visualSizeGradeOnly),
      TopicResultDisplay.duration => _buildDuration(duration),
      TopicResultDisplay.gradeAndDuration => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          main(gradeScale, _visualSizeGradeAndDuration),
          const SizedBox(height: 1),
          _buildDuration(duration),
        ],
      ),
    };
  }

  Widget _buildStreak(int streak) {
    // Колір в обох режимах, більший розмір лише в дитячому.
    final iconSize = kidsMode ? 40.0 : 18.0;
    final fontSize = kidsMode ? 28.0 : _gradeFontSize;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            size: iconSize,
            color: Colors.deepOrange,
          ),
          Text(
            '$streak',
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildGrade(
    GradeScale scale,
    TopicAttemptSnapshot snapshot, {
    required double visualSize,
  }) {
    if (scale == GradeScale.visual || scale == GradeScale.emoji) {
      return Center(
        child: SizedBox(
          width: visualSize,
          height: visualSize,
          child: FittedBox(
            fit: BoxFit.contain,
            child: GradeMark(
              score: snapshot.score,
              isPassed: snapshot.isPassed,
              scale: scale,
              size: visualSize,
            ),
          ),
        ),
      );
    }

    return Text(
      scale.formatScore(snapshot.score),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: _gradeFontSize,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDuration(String duration) {
    return Text(
      duration,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: _durationFontSize),
    );
  }
}
