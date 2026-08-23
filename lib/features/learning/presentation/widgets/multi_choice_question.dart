import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class MultiChoiceQuestion extends StatelessWidget {
  const MultiChoiceQuestion({
    super.key,
    required this.condition,
    this.imagePath,
  });

  final String condition;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          condition,
          style: AppTextStyles.headline,
          textAlign: TextAlign.center,
        ),

        if (imagePath != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Image.asset(imagePath!),
        ],
      ],
    );
  }
}
