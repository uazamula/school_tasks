import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/preferences/preferences_provider.dart';
import 'package:school_tasks/core/theme/theme_controller.dart';
import 'package:school_tasks/features/learning/providers/grade_scale_controller.dart';
import 'package:school_tasks/features/learning/providers/topic_result_attempt_controller.dart';
import 'package:school_tasks/features/learning/providers/topic_result_display_controller.dart';
import 'package:school_tasks/features/settings/providers/service_sounds_controller.dart';

class ResetSettingsSection extends ConsumerWidget {
  const ResetSettingsSection({super.key});

  Future<void> _reset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Відновити налаштування?'),
        content: const Text(
          'Тема, шкала оцінювання, відображення результату та звуки '
          'повернуться до значень за замовчуванням. '
          'Мова й режим інтерфейсу не зміняться.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Скасувати'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Відновити'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final preferences = await ref.read(appPreferencesProvider.future);
    await preferences.resetUiSettings();

    // Контролери перечитують сховище й повертаються до профілю.
    ref.invalidate(themeControllerProvider);
    ref.invalidate(gradeScaleControllerProvider);
    ref.invalidate(topicResultAttemptControllerProvider);
    ref.invalidate(topicResultDisplayControllerProvider);
    ref.invalidate(serviceSoundsControllerProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.restore),
      title: const Text('Відновити налаштування за замовчуванням'),
      onTap: () => _reset(context, ref),
    );
  }
}
