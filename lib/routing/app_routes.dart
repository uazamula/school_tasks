abstract final class AppRoutes {
  static const home = '/';
  static const settings = '/settings';
  static const profile = '/profile';

  static String learningFor(String topicId) {
    return '/learning/$topicId';
  }
}
