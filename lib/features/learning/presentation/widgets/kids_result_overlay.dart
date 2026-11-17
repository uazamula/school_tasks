import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';
import 'package:school_tasks/features/learning/domain/topic_result_kind.dart';
import 'package:school_tasks/features/learning/presentation/widgets/visual_grade_scale_widget.dart';

/// Повноекранний результат теми для дитячого режиму:
/// оцінка з анімацією та одна велика кнопка «Далі».
class KidsResultOverlay extends StatefulWidget {
  const KidsResultOverlay({
    super.key,
    required this.result,
    required this.onContinue,
  });

  final TopicResult result;
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
              ScaleTransition(scale: _scale, child: _buildResult()),
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
          Text(
            '${result.bestStreak}',
            style: const TextStyle(
              fontSize: _resultSize * 0.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    // Тут пізніше підставимо шкалу з емодзі (п. 8).
    return VisualGradeScaleWidget(
      score: result.currentScore,
      size: _resultSize,
    );
  }
}
