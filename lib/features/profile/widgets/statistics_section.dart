import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/formatters/duration_formatter.dart';
import 'package:school_tasks/core/statistics/usage_statistics_controller.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/core/extensions/context_extension.dart';

import 'statistic_tile.dart';

class StatisticsSection extends ConsumerWidget {
  const StatisticsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statistics = ref.watch(usageStatisticsControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.statistics,
          style: Theme.of(context).textTheme.titleLarge,
        ),

        const SizedBox(height: AppSpacing.md),

        StatisticTile(
          title: context.l10n.usageTime,
          value: DurationFormatter.format(context, statistics.totalUsage),
        ),

        StatisticTile(
          title: context.l10n.todayUsageTime,
          value: DurationFormatter.format(context, statistics.todayUsage),
        ),
      ],
    );
  }
}
