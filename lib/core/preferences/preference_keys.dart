abstract final class PreferenceKeys {
  static const themeMode = 'themeMode';
  static const languageCode = 'languageCode';
  static const gradeScale = 'gradeScale';

  static const profileName = 'profileName';
  static const profileAvatar = 'profileAvatar';

  static const usageTotalSeconds = 'usage_total_seconds';
  static const usageTodaySeconds = 'usage_today_seconds';
  static const usageDate = 'usage_date';

  static const topicResultPrefix = 'topic_result_';

  static String topicResult(String topicId) {
    return '$topicResultPrefix$topicId';
  }
}