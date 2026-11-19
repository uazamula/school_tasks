import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/evaluation/grade_scale.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';
import 'package:school_tasks/features/learning/domain/topic_result_kind.dart';
import 'package:school_tasks/features/learning/presentation/widgets/grade_mark.dart';

/// Повноекранний результат теми для дитячого режиму:
/// оцінка з анімацією та одна велика кнопка «Далі».
class KidsResultOverlay extends StatefulWidget {
  const KidsResultOverlay({
    super.key,
    required this.result,
    required this.scale,
    required this.onContinue,
  });

  final TopicResult result;

  /// Шкала для дитячого режиму (візуальна або емодзі).
  final GradeScale scale;
  final VoidCallback onContinue;

  @override
  State<KidsResultOverlay> createState() => _KidsResultOverlayState();
}

class _KidsResultOverlayState extends State<KidsResultOverlay>
    with SingleTickerProviderStateMixin {
  static const double _resultSize = 180;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();

  // Оцінка «вистрибує» з пружинним ефектом.
  late final Animation<double> _scale = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.7, curve: Curves.elasticOut),
  );

  // Кнопка з'являється після оцінки.
  late final Animation<double> _buttonOpacity = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.7, 1, curve: Curves.easeIn),
  );

  // Новий рекорд: найкраща спроба збігається з поточною.
  bool get _isNewRecord {
    final result = widget.result;
    final best = result.bestAttempt;

    return best != null &&
        best.completedAt == result.currentAttempt.completedAt &&
        result.currentStreak > 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _scale,
                // Ряд зменшується, якщо не вміщується (двозначна серія).
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _buildResult(),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              FadeTransition(
                opacity: _buttonOpacity,
                child: FilledButton.icon(
                  onPressed: widget.onContinue,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 40),
                  label: const Text('Далі', style: TextStyle(fontSize: 32)),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(220, 88),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResult() {
    final result = widget.result;

    if (result.kind == TopicResultKind.streak) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department,
            size: _resultSize * 0.7,
            color: Colors.deepOrange,
          ),
          // Завжди результат щойно зіграної спроби, а не рекорд.
          Text(
            '${result.currentStreak}',
            style: const TextStyle(
              fontSize: _resultSize * 0.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_isNewRecord)
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text('🏆', style: TextStyle(fontSize: _resultSize * 0.5)),
            ),
        ],
      );
    }

    return GradeMark(
      score: result.currentScore,
      isPassed: result.currentIsPassed,
      scale: widget.scale,
      size: _resultSize,
    );
  }
}
