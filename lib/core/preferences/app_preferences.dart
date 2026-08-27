import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_tasks/core/model/usage_statistics.dart';
import 'package:school_tasks/core/preferences/preference_values.dart';
import 'package:school_tasks/features/learning/domain/evaluation/grade_scale.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';
import 'package:school_tasks/features/profile/model/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'preference_keys.dart';

class AppPreferences {
  AppPreferences(this._prefs);

  final SharedPreferences _prefs;

  ThemeMode getThemeMode() {
    final value = _prefs.getString(PreferenceKeys.themeMode);

    switch (value) {
      case PreferenceValues.light:
        return ThemeMode.light;

      case PreferenceValues.dark:
        return ThemeMode.dark;

      default:
        return ThemeMode.system;
    }
  }

  Future<bool> setThemeMode(ThemeMode mode) {
    return _prefs.setString(PreferenceKeys.themeMode, switch (mode) {
      ThemeMode.light => PreferenceValues.light,
      ThemeMode.dark => PreferenceValues.dark,
      ThemeMode.system => PreferenceValues.system,
    });
  }

  Locale getLocale() {
    final languageCode = _prefs.getString(PreferenceKeys.languageCode);

    if (languageCode == null) {
      return const Locale(PreferenceValues.uk);
    }

    return Locale(languageCode);
  }

  Future<bool> setLocale(Locale locale) {
    return _prefs.setString(PreferenceKeys.languageCode, locale.languageCode);
  }

  GradeScale getGradeScale() {
    final value = _prefs.getString(PreferenceKeys.gradeScale);

    switch (value) {
      case PreferenceValues.gradeScaleTwelve:
        return GradeScale.twelve;

      case PreferenceValues.gradeScaleHundred:
      default:
        return GradeScale.hundred;
    }
  }

  Future<bool> setGradeScale(GradeScale scale) {
    return _prefs.setString(PreferenceKeys.gradeScale, switch (scale) {
      GradeScale.hundred => PreferenceValues.gradeScaleHundred,
      GradeScale.twelve => PreferenceValues.gradeScaleTwelve,
    });
  }

  UserProfile getUserProfile() {
    return UserProfile(
      name: _prefs.getString(PreferenceKeys.profileName) ?? 'Користувач',
      avatar: _prefs.getString(PreferenceKeys.profileAvatar) ?? '🙂',
    );
  }

  Future<bool> setUserProfile(UserProfile profile) async {
    final nameSaved = await _prefs.setString(
      PreferenceKeys.profileName,
      profile.name,
    );

    final avatarSaved = await _prefs.setString(
      PreferenceKeys.profileAvatar,
      profile.avatar,
    );

    return nameSaved && avatarSaved;
  }

  UsageStatistics getUsageStatistics() {
    return UsageStatistics(
      totalUsage: Duration(
        seconds: _prefs.getInt(PreferenceKeys.usageTotalSeconds) ?? 0,
      ),
      todayUsage: Duration(
        seconds: _prefs.getInt(PreferenceKeys.usageTodaySeconds) ?? 0,
      ),
    );
  }

  Future<void> setUsageStatistics(
    UsageStatistics statistics,
    DateTime todayDate,
  ) async {
    await _prefs.setInt(
      PreferenceKeys.usageTotalSeconds,
      statistics.totalUsage.inSeconds,
    );

    await _prefs.setInt(
      PreferenceKeys.usageTodaySeconds,
      statistics.todayUsage.inSeconds,
    );

    await _prefs.setString(
      PreferenceKeys.usageDate,
      todayDate.toIso8601String(),
    );
  }

  DateTime? getUsageDate() {
    final value = _prefs.getString(PreferenceKeys.usageDate);

    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  DateTime? getUsageTodayDate() {
    final value = _prefs.getString(PreferenceKeys.usageDate);

    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  TopicResult? getTopicResult(String topicId) {
    final value = _prefs.getString(PreferenceKeys.topicResult(topicId));

    if (value == null) {
      return null;
    }

    try {
      final json = jsonDecode(value) as Map<String, dynamic>;

      return TopicResult.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<bool> setTopicResult(String topicId, TopicResult result) {
    return _prefs.setString(
      PreferenceKeys.topicResult(topicId),
      jsonEncode(result.toJson()),
    );
  }

  Future<bool> clearTopicResult(String topicId) {
    return _prefs.remove(PreferenceKeys.topicResult(topicId));
  }
}
