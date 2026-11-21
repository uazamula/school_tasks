import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/ui/active_profile_provider.dart';
import 'package:school_tasks/core/ui/kids_ui_controller.dart';
import 'package:school_tasks/features/learning/domain/evaluation/grade_scale.dart';
import 'package:school_tasks/features/learning/providers/grade_scale_controller.dart';

/// Шкала, що діє зараз: вибір користувача або значення профілю.
final effectiveGradeScaleProvider = FutureProvider<GradeScale>((ref) async {
  final chosen = await ref.watch(gradeScaleControllerProvider.future);
  // Режим має бути завантажений, щоб профіль був правильним.
  await ref.watch(kidsUiControllerProvider.future);

  return chosen ?? ref.read(activeProfileProvider).gradeScale;
});
