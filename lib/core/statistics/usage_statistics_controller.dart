import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:school_tasks/core/model/usage_statistics.dart';

part 'usage_statistics_controller.g.dart';

@Riverpod(keepAlive: true)
class UsageStatisticsController extends _$UsageStatisticsController {
  @override
  UsageStatistics build() {
    return const UsageStatistics(
      totalUsage: Duration.zero,
      todayUsage: Duration.zero,
    );
  }

  void update(UsageStatistics statistics) {
    state = statistics;
  }
}
