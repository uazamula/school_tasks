import 'package:flutter/material.dart';

import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/falling_option_bubble.dart';

class SlotAssemblyFlightAnimation extends StatefulWidget {
  const SlotAssemblyFlightAnimation({super.key});

  @override
  State<SlotAssemblyFlightAnimation> createState() =>
      SlotAssemblyFlightAnimationState();
}

class SlotAssemblyFlightAnimationState
    extends State<SlotAssemblyFlightAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  OverlayEntry? _overlayEntry;
  Rect? _startRect;
  Rect? _endRect;
  String? _text;
  Color? _color;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  Future<bool> animate({
    required Rect startRect,
    required Rect endRect,
    required String text,
    required Color color,
  }) async {
    if (!mounted) return false;

    _removeOverlay();

    final overlay = Overlay.of(context, rootOverlay: true);
    final overlayBox =
    overlay.context.findRenderObject() as RenderBox;

    _startRect = Rect.fromLTWH(
      overlayBox.globalToLocal(startRect.topLeft).dx,
      overlayBox.globalToLocal(startRect.topLeft).dy,
      startRect.width,
      startRect.height,
    );

    _endRect = Rect.fromLTWH(
      overlayBox.globalToLocal(endRect.topLeft).dx,
      overlayBox.globalToLocal(endRect.topLeft).dy,
      endRect.width,
      endRect.height,
    );

    _text = text;
    _color = color;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final rect = Rect.lerp(
              _startRect,
              _endRect,
              _controller.value,
            )!;

            return Positioned.fromRect(
              rect: rect,
              child: FallingOptionBubble(
                text: _text!,
                color: _color!,
                size: rect.width,
                onTap: () {},
              ),
            );
          },
        );
      },
    );

    overlay.insert(_overlayEntry!);

    var completed = false;

    try {
      _controller.reset();
      await _controller.forward().orCancel;
      completed = true;
    } on TickerCanceled {
      // Анімацію було скасовано.
    } finally {
      _removeOverlay();
    }

    return completed && mounted;
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
