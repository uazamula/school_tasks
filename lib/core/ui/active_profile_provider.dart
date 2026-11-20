import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/config/app_config.dart';
import 'package:school_tasks/core/config/ui_profile.dart';
import 'package:school_tasks/core/ui/kids_ui_controller.dart';

/// Профіль за замовчуванням, що відповідає поточному режиму інтерфейсу.
final activeProfileProvider = Provider<UiProfile>((ref) {
  final kidsUi =
      ref.watch(kidsUiControllerProvider).value ?? AppConfig.kidsUiDefault;

  return kidsUi ? AppConfig.kidsProfile : AppConfig.adultProfile;
});