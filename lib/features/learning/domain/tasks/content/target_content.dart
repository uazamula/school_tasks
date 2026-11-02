import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';

enum TargetEffectType {
  /// Для зображень: чорно-біле → кольорове.
  saturation,

  /// Для тексту: поступово зростаюче світіння.
  glow,
}

class TargetEffectConfig {
  const TargetEffectConfig({
    this.type = TargetEffectType.saturation,
    this.steps,
  }) : assert(steps == null || steps > 0);

  final TargetEffectType type;

  /// Кількість переходів від початкового стану до фінального.
  /// Якщо null — визначається автоматично за кількістю елементів,
  /// які треба скласти (див. [resolveSteps]).
  final int? steps;

  /// Явно задані [steps] мають пріоритет. Інакше береться [totalSlots],
  /// а якщо він невідомий — 1.
  int resolveSteps(int? totalSlots) {
    if (steps != null) return steps!;
    if (totalSlots != null && totalSlots > 0) return totalSlots;
    return 1;
  }
}

class TargetContent {
  const TargetContent({required this.target, this.effect});

  /// Основний ресурс, наприклад кольорове зображення корови.
  final TaskContent target;

  /// Конфігурація візуального ефекту.
  /// Якщо null — ціль відображається без ефекту.
  final TargetEffectConfig? effect;
}
