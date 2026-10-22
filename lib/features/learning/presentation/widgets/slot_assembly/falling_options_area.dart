import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/falling_option_bubble.dart';

class FallingOptionsArea extends StatefulWidget {
  const FallingOptionsArea({
    super.key,
    required this.animation,
    required this.optionIndex,
    required this.text,
    required this.canStart,
    required this.onStartFalling,
    required this.onOptionTapped,
    required this.colorSeed,
    this.width = 240,
    this.height = 360,
    this.elementSize = 48,
  });

  final Animation<double> animation;
  final int? optionIndex;
  final String? text;
  final bool canStart;
  final VoidCallback onStartFalling;
  final ValueChanged<int> onOptionTapped;
  final Object colorSeed;

  final double width;
  final double height;
  final double elementSize;

  @override
  State<FallingOptionsArea> createState() => _FallingOptionsAreaState();
}

class _FallingOptionsAreaState extends State<FallingOptionsArea> {
  static const List<Color> _bubbleColors = [
    Color(0xFF2879C7),
    Color(0xFF159B88),
    Color(0xFF8054C7),
    Color(0xFFD66B35),
    Color(0xFFC74770),
    Color(0xFF647D35),
  ];

  final Map<int, Color> _bubbleColorsByOption = {};

  bool _fallingAreaStarted = false;

  @override
  void didUpdateWidget(covariant FallingOptionsArea oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.colorSeed != widget.colorSeed) {
      _bubbleColorsByOption.clear();
    }
  }

  Color _bubbleColorFor(int optionIndex) {
    return _bubbleColorsByOption.putIfAbsent(
      optionIndex,
      () => _bubbleColors[math.Random().nextInt(_bubbleColors.length)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (!_fallingAreaStarted) {
              _fallingAreaStarted = true;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && widget.canStart) {
                  widget.onStartFalling();
                }
              });
            }

            return ClipRect(
              child: AnimatedBuilder(
                animation: widget.animation,
                builder: (context, child) {
                  final optionIndex = widget.optionIndex;
                  final text = widget.text;

                  if (optionIndex == null || text == null) {
                    return const SizedBox.expand();
                  }

                  final availableHeight =
                      (constraints.maxHeight - widget.elementSize).clamp(
                        0.0,
                        double.infinity,
                      );

                  final top = availableHeight * widget.animation.value;

                  return Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Positioned(
                        top: top,
                        left: (constraints.maxWidth - widget.elementSize) / 2,
                        width: widget.elementSize,
                        height: widget.elementSize,
                        child: FallingOptionBubble(
                          text: text,
                          color: _bubbleColorFor(optionIndex),
                          size: widget.elementSize,
                          onTap: () => widget.onOptionTapped(optionIndex),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
