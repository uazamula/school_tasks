import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/ui/active_profile_provider.dart';
import 'package:school_tasks/core/theme/theme_app_theme_choice.dart';
import 'package:school_tasks/core/theme/theme_controller.dart';

/// Тема, що діє зараз: вибір користувача або значення профілю.
final effectiveThemeChoiceProvider = Provider<AppThemeChoice>((ref) {
  final chosen = ref.watch(themeControllerProvider).value;

  return chosen ?? ref.watch(activeProfileProvider).themeChoice;
});