import 'package:flutter/material.dart';
import 'package:latext/latext.dart';

class MathContentWidget extends StatelessWidget {
  const MathContentWidget({required this.expression, this.style, super.key});

  final String expression;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return LaTexT(
      laTeXCode: Text(
        expression,
        style: style ?? Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
