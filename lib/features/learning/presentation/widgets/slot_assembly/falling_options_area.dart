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
    this.width = 280,
    this.height = 360,
    this.elementSize = 60,
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

  static const int _maxColumns = 4;

  final Map<int, Color> _bubbleColorsByOption = {};

  bool _fallingAreaStarted = false;

  @override
  void initState() {
    super.initState();

    if (widget.canStart) {
      _scheduleFallingStart();
    }
  }

  @override
  void didUpdateWidget(covariant FallingOptionsArea oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.colorSeed != widget.colorSeed) {
      _bubbleColorsByOption.clear();
    }

    if (widget.canStart && !oldWidget.canStart) {
      _scheduleFallingStart();
    }
  }

  void _scheduleFallingStart() {
    if (_fallingAreaStarted) return;

    _fallingAreaStarted = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.canStart) {
        widget.onStartFalling();
      } else if (mounted) {
        // Allow a later update to start the animation when canStart
        // becomes true.
        _fallingAreaStarted = false;
      }
    });
  }

  Color _bubbleColorFor(int optionIndex) {
    return _bubbleColorsByOption.putIfAbsent(
      optionIndex,
      () => _bubbleColors[math.Random().nextInt(_bubbleColors.length)],
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = _buildRows(widget.optionIndices);
    final rowCount = rows.length;

    // Each row uses a fixed set of slots. Hidden bubbles keep their space,
    // so selecting one does not move the remaining bubbles.
    final gridHeight = rowCount == 0
        ? 0.0
        : rowCount * widget.elementSize + (rowCount - 1) * widget.spacing;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ClipRect(
              child: AnimatedBuilder(
                animation: widget.animation,
                builder: (context, child) {
                  final availableHeight = math.max(
                    0.0,
                    constraints.maxHeight - gridHeight,
                  );

                  final top = availableHeight * widget.animation.value;

                  return Stack(
                    children: [
                      Positioned(
                        top: top,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (var row = 0; row < rowCount; row++) ...[
                              if (row > 0) SizedBox(height: widget.spacing),
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for (
                                      var column = 0;
                                      column < rows[row].length;
                                      column++
                                    ) ...[
                                      if (column > 0)
                                        SizedBox(width: widget.spacing),
                                      _buildBubble(rows[row][column]),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ],
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
                    renderObject.localToGlobal(Offset.zero) & renderObject.size;

                widget.onOptionTapped(optionIndex, sourceRect, bubbleColor);
              },
            ),
          );
        },
      ),
    );
  }

  List<List<int>> _buildRows(List<int> optionIndices) {
    final itemCount = optionIndices.length;
    if (itemCount == 0) return [];

    final rowCount = (itemCount + _maxColumns - 1) ~/ _maxColumns;
    final baseCount = itemCount ~/ rowCount;
    final extraCount = itemCount % rowCount;

    var offset = 0;
    return List.generate(rowCount, (rowIndex) {
      final count = baseCount + (rowIndex < extraCount ? 1 : 0);
      final row = optionIndices.sublist(offset, offset + count);
      offset += count;
      return row;
    });
  }
}
