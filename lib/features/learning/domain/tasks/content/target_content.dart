import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';

enum TargetEffectType {
  /// Для зображень: чорно-біле → кольорове.
  saturation,

  /// Для тексту: поступово зростаюче світіння.
  glow,

  /// Для зображень: глибина кольору зростає з прогресом.
  colorDepth,
}

class TargetEffectConfig {
  const TargetEffectConfig({
    this.type = TargetEffectType.saturation,
    this.steps,
  }) : assert(steps == null || steps > 0);

  final TargetEffectType type;

  /// Кількість переходів від початкового стану до фінального.
  /// Якщо null — визначається автоматично (див. [resolveSteps]).
  final int? steps;

  int resolveSteps(int? totalSlots) {
    if (steps != null) return steps!;
    if (totalSlots != null && totalSlots > 0) return totalSlots;
    return 1;
  }

  /// Біт на канал для [TargetEffectType.colorDepth]
  /// за поточного [progress]; null — оригінал.
  int? bitsForProgress(int progress, int steps) {
    if (progress >= steps) return null;
    final index = progress < 0 ? 0 : progress;
    return _colorDepthLevels(steps)[index];
  }

  /// Рівні до оригіналу: 1, 2, 4, а далі рівномірно між 4 і 8 бітами
  /// (5…7), по одному рівню на кожен додатковий крок.
  /// Рівні в бітах на піксель (палітра з 2^біт кольорів):
  /// 1, 2, 4, а далі між 4 і 8 бітами (5…8), далі — оригінал.
  static List<int> _colorDepthLevels(int steps) {
    const base = [1, 2, 4];
    if (steps <= base.length) return base.sublist(0, steps);

    const extraLevels = [5, 6, 7, 8];
    final extra = steps - base.length;

    return [
      ...base,
      if (extra == 1)
        8
      else
        for (var j = 0; j < extra; j++)
          extraLevels[(j * (extraLevels.length - 1) / (extra - 1)).round()],
    ];
  }
}
class TargetContent {
  const TargetContent({required this.target, this.effect, this.fontSize})
    : assert(fontSize == null || fontSize > 0);

  /// Основний ресурс, наприклад кольорове зображення корови.
  final TaskContent target;

  /// Конфігурація візуального ефекту.
  /// Якщо null — ціль відображається без ефекту.
  final TargetEffectConfig? effect;

  /// Розмір шрифта, якщо ціль — текст ([TextContent]).
  /// null — береться розмір зі стилю умови завдання.
  final double? fontSize;
}
