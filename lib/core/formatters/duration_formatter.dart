import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:school_tasks/core/extensions/context_extension.dart';

abstract final class DurationFormatter {
  /// Існуюче форматування для статистики використання.
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

  /// Коротке форматування для індикатора результату:
  /// m:ss.t
  ///
  /// Якщо тривалість більша за 9:59.9 — повертається ∞.
  static String formatShort(BuildContext context, Duration duration) {
    final tenths = duration.inMilliseconds ~/ 100;

    const maxTenths = 5999;

    if (tenths > maxTenths) {
      return '∞';
    }

    final minutes = tenths ~/ 600;
    final seconds = (tenths ~/ 10) % 60;
    final tenth = tenths % 10;

    final decimalSeparator = _decimalSeparator(context);

    return '$minutes:${seconds.toString().padLeft(2, '0')}'
        '$decimalSeparator$tenth';
  }

  /// Детальне форматування:
  /// mm:ss.xxx
  static String formatDetailed(BuildContext context, Duration duration) {
    final milliseconds = duration.inMilliseconds;

    final minutes = milliseconds ~/ 60000;
    final seconds = (milliseconds ~/ 1000) % 60;
    final remainingMilliseconds = milliseconds % 1000;

    final decimalSeparator = _decimalSeparator(context);

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}'
        '$decimalSeparator'
        '${remainingMilliseconds.toString().padLeft(3, '0')}';
  }

  static String _decimalSeparator(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return NumberFormat.decimalPattern(
      locale.toLanguageTag(),
    ).symbols.DECIMAL_SEP;
  }
}
