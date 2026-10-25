
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/falling_option_bubble.dart';

class FallingOptionsArea extends StatefulWidget {
  const FallingOptionsArea({
    super.key,
    required this.animation,
    required this.optionIndices,
    required this.textForOption,
    required this.hiddenOptionIndices,
    required this.canStart,
    required this.onStartFalling,
    required this.onOptionTapped,
    required this.colorSeed,
    this.width = 240,
    this.height = 360,
    this.elementSize = 48,
    this.spacing = 8,
  });

  final Animation<double> animation;
  final List<int> optionIndices;
  final String Function(int optionIndex) textForOption;
  final Set<int> hiddenOptionIndices;
  final bool canStart;
  final VoidCallback onStartFalling;
  final void Function(int optionIndex, Rect sourceRect, Color color)
  onOptionTapped;
  final Object colorSeed;

  final double width;
  final double height;
  final double elementSize;
  final double spacing;

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
          () => _bubbleColors[
      math.Random().nextInt(_bubbleColors.length)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.optionIndices.length;
    final rowWidth = itemCount == 0
        ? widget.width
        : itemCount * widget.elementSize +
        (itemCount - 1) * widget.spacing;
    final areaWidth = math.max(widget.width, rowWidth);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: SizedBox(
        height: widget.height,
        width: areaWidth,
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
                  final availableHeight =
                  (constraints.maxHeight - widget.elementSize).clamp(
                    0.0,
                    double.infinity,
                  );

                  final top = availableHeight * widget.animation.value;

                  return Stack(
                    children: [
                      Positioned(
                        top: top,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (var i = 0;
                              i < widget.optionIndices.length;
                              i++) ...[
                                if (i > 0)
                                  SizedBox(width: widget.spacing),
                                _buildBubble(
                                  widget.optionIndices[i],
                                ),
                              ],
                            ],
                          ),
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

  Widget _buildBubble(int optionIndex) {
    final bubbleColor = _bubbleColorFor(optionIndex);

    return SizedBox(
      width: widget.elementSize,
      height: widget.elementSize,
      child: Builder(
        builder: (bubbleContext) {
          return Visibility(
            visible: !widget.hiddenOptionIndices.contains(optionIndex),
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: FallingOptionBubble(
              text: widget.textForOption(optionIndex),
              color: bubbleColor,
              size: widget.elementSize,
              onTap: () {
                if (!widget.canStart ||
                    widget.hiddenOptionIndices.contains(optionIndex)) {
                  return;
                }

                final renderObject = bubbleContext.findRenderObject();

                if (renderObject is! RenderBox ||
                    !renderObject.hasSize ||
                    !renderObject.attached) {
                  return;
                }

                final sourceRect =
                renderObject.localToGlobal(Offset.zero) &
                renderObject.size;

                widget.onOptionTapped(
                  optionIndex,
                  sourceRect,
                  bubbleColor,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
