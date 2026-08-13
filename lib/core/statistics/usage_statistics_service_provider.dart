import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:school_tasks/core/preferences/preferences_provider.dart';
import 'package:school_tasks/core/services/usage_statistics_service.dart';
import 'package:school_tasks/core/statistics/usage_statistics_controller.dart';

part 'usage_statistics_service_provider.g.dart';

@Riverpod(keepAlive: true)
Future<void> usageStatisticsService(Ref ref) async {
  final preferences = await ref.watch(appPreferencesProvider.future);

  final controller = ref.read(usageStatisticsControllerProvider.notifier);

  final service = UsageStatisticsService(
    preferences,
    onChanged: controller.update,
  );

  await service.initialize();

  ref.onDispose(service.dispose);
}
