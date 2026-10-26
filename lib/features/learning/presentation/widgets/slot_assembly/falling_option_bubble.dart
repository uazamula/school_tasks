import 'dart:math' as math;

import 'package:flutter/material.dart';

class FallingOptionBubble extends StatelessWidget {
  const FallingOptionBubble({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
    this.onPointerDown,
    this.size = 48,
  });

  final String text;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback? onPointerDown;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Listener(
      onPointerDown: (_) => onPointerDown?.call(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: Color.lerp(color, Colors.white, 0.55)!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(size * 0.08),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              maxLines: 1,
              softWrap: false,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
