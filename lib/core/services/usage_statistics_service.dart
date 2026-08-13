import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:school_tasks/core/model/usage_statistics.dart';
import 'package:school_tasks/core/preferences/app_preferences.dart';

class UsageStatisticsService extends WidgetsBindingObserver {
  UsageStatisticsService(this._preferences, {this.onChanged});

  final AppPreferences _preferences;
  final void Function(UsageStatistics)? onChanged;

  Timer? _timer;

  UsageStatistics _statistics = const UsageStatistics(
    totalUsage: Duration.zero,
    todayUsage: Duration.zero,
  );

  DateTime? _lastUpdate;

  Future<void> initialize() async {
    WidgetsBinding.instance.addObserver(this);

    _statistics = _preferences.getUsageStatistics();

    onChanged?.call(_statistics);

    final savedDate = _preferences.getUsageDate();

    if (savedDate == null || !_isSameDay(savedDate, DateTime.now())) {
      _statistics = _statistics.copyWith(todayUsage: Duration.zero);

      onChanged?.call(_statistics);

      await _preferences.setUsageStatistics(_statistics, DateTime.now());
    }

    _startSession();
  }

  void _startSession() {
    _lastUpdate = DateTime.now();

    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _commitElapsed(),
    );
  }

  Future<void> _commitElapsed() async {
    final from = _lastUpdate;

    if (from == null) {
      return;
    }

    final to = DateTime.now();

    if (_isSameDay(from, to)) {
      final elapsed = to.difference(from);

      _statistics = _statistics.copyWith(
        totalUsage: _statistics.totalUsage + elapsed,
        todayUsage: _statistics.todayUsage + elapsed,
      );
    } else {
      final midnight = DateTime(to.year, to.month, to.day);

      final beforeMidnight = midnight.difference(from);
      final afterMidnight = to.difference(midnight);

      _statistics = _statistics.copyWith(
        totalUsage: _statistics.totalUsage + beforeMidnight + afterMidnight,
        todayUsage: afterMidnight,
      );
    }

    _lastUpdate = to;

    onChanged?.call(_statistics);

    await _preferences.setUsageStatistics(_statistics, to);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_timer == null || !_timer!.isActive) {
          _startSession();
        }
        break;

      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        unawaited(_commitElapsed());

        _lastUpdate = null;

        _timer?.cancel();

        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        break;
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _timer?.cancel();
  }

  UsageStatistics get statistics => _statistics;
}
