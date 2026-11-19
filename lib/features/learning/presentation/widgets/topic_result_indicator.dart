import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:school_tasks/core/config/app_config.dart';
import 'package:school_tasks/core/formatters/duration_formatter.dart';
import 'package:school_tasks/features/learning/domain/evaluation/grade_scale.dart';
import 'package:school_tasks/features/learning/domain/evaluation/topic_result_attempt.dart';
import 'package:school_tasks/features/learning/domain/evaluation/topic_result_display.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';
import 'package:school_tasks/features/learning/domain/topic_result_kind.dart';
import 'package:school_tasks/features/learning/presentation/widgets/grade_mark.dart';
import 'package:school_tasks/features/learning/providers/effective_grade_scale_provider.dart';
import 'package:school_tasks/features/learning/providers/topic_result_attempt_controller.dart';
import 'package:school_tasks/features/learning/providers/topic_result_display_controller.dart';

class TopicResultIndicator extends ConsumerWidget {
  const TopicResultIndicator({
    super.key,
    required this.result,
    this.kidsMode = false,
  });

  final TopicResult? result;

  /// Дитячий режим: більші елементи, без часу.
  final bool kidsMode;

  static const double _gradeFontSize = 20;
  static const double _durationFontSize = 12;

  static const double _markSizeGradeOnly = 56;
  static const double _markSizeGradeAndDuration = 46;
  static const double _markSizeKids = 72;

  /// Порожній стан («ще не грали»): зірочка для дітей, прочерк для дорослих.
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
    final scaleAsync = ref.watch(effectiveGradeScaleProvider);
    final displayAsync = ref.watch(topicResultDisplayControllerProvider);

    if (attemptAsync.isLoading ||
        scaleAsync.isLoading ||
        displayAsync.isLoading ||
        attemptAsync.hasError ||
        scaleAsync.hasError ||
        displayAsync.hasError) {
      return _buildEmpty();
    }

    // Вибір користувача або значення за замовчуванням для режиму.
    final attemptKind =
        attemptAsync.value ??
        (kidsMode
            ? AppConfig.kidsResultAttemptDefault
            : AppConfig.resultAttemptDefault);

    final snapshot = attemptKind == TopicResultAttempt.best
        ? stored.bestAttempt
        : stored.currentAttempt;

    final isStreak = stored.kind == TopicResultKind.streak;

    // Серія без найкращої спроби: показувати нічого.
    if (snapshot == null && isStreak) {
      return _buildEmpty();
    }

    final scale = scaleAsync.value!;

    // Для оцінки без зарахованої найкращої спроби: 🤷 (грали, не зарахували).
    Widget main(double markSize) {
      if (isStreak) {
        return _buildStreak(snapshot!.streak ?? 0);
      }

      return _buildGrade(
        scale,
        score: snapshot?.score ?? 0,
        isPassed: snapshot?.isPassed ?? false,
        size: markSize,
      );
    }

    if (kidsMode) {
      return main(_markSizeKids);
    }

    final display = displayAsync.value!;

    // Тривалість з тієї ж спроби, що й оцінка; без неї береться остання.
    final durationSource = snapshot ?? stored.currentAttempt;
    final duration = DurationFormatter.formatShort(
      context,
      durationSource.duration,
    );

    return switch (display) {
      TopicResultDisplay.grade => main(_markSizeGradeOnly),
      TopicResultDisplay.duration => _buildDuration(duration),
      TopicResultDisplay.gradeAndDuration => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          main(_markSizeGradeAndDuration),
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
    GradeScale scale, {
    required double score,
    required bool isPassed,
    required double size,
  }) {
    return GradeMark(
      score: score,
      isPassed: isPassed,
      scale: scale,
      size: size,
    );
  }

  Widget _buildDuration(String duration) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        duration,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: _durationFontSize),
      ),
    );
  }
}
