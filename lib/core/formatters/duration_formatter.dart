import 'package:flutter/widgets.dart';

import 'package:school_tasks/core/extensions/context_extension.dart';

abstract final class DurationFormatter {
  static String format(BuildContext context, Duration duration) {
    final totalMinutes = duration.inMinutes;

    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours == 0) {
      return '${minutes} ${context.l10n.minutesShort}';
    }

    return '$hours ${context.l10n.hoursShort} '
        '${minutes.toString().padLeft(2, '0')} '
        '${context.l10n.minutesShort}';
  }
}
