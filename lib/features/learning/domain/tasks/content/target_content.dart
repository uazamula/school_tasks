
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';

enum TargetEffectType {
  saturation,
}

class TargetEffectConfig {
  const TargetEffectConfig({
    this.type = TargetEffectType.saturation,
    this.steps = 1,
  }) : assert(steps > 0);

  final TargetEffectType type;

  /// Кількість переходів від початкового стану до фінального.
  final int steps;
}

class TargetContent {
  const TargetContent({
    required this.target,
    this.effect,
  });

  /// Основний ресурс, наприклад кольорове зображення корови.
  final TaskContent target;

  /// Конфігурація візуального ефекту.
  /// Якщо null — ціль відображається без ефекту.
  final TargetEffectConfig? effect;
}
