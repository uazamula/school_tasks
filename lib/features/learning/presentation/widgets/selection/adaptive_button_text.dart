import 'package:flutter/material.dart';

class AdaptiveButtonText extends StatelessWidget {
  const AdaptiveButtonText({
    super.key,
    required this.text,
    required this.textStyle,
    this.textScaler,
    this.textAlign = TextAlign.center,
  });

  final String text;
  final TextStyle textStyle;
  final TextScaler? textScaler;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: constraints.maxWidth,
            child: Text(
              text,
              textAlign: textAlign,
              softWrap: true,
              style: textStyle,
              textScaler: textScaler,
            ),
          ),
        );
      },
    );
  }
}
