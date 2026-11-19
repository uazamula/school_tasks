import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:school_tasks/core/preferences/preferences_provider.dart';
import 'package:school_tasks/features/learning/domain/evaluation/grade_scale.dart';

// dart run build_runner build - у терміналі
part 'grade_scale_controller.g.dart';

/// Вибір користувача; null означає, що діє значення за замовчуванням.
@Riverpod(keepAlive: true)
class GradeScaleController extends _$GradeScaleController {
  @override
  Future<GradeScale?> build() async {
    final preferences = await ref.watch(appPreferencesProvider.future);

    return preferences.getGradeScale();
  }

  Future<void> setGradeScale(GradeScale scale) async {
    final preferences = await ref.read(appPreferencesProvider.future);

    await preferences.setGradeScale(scale);

    state = AsyncData(scale);
  }
}
