import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';

enum TargetEffectType {
  saturation,
  glow,

  /// Для зображень: глибина кольору зростає, фіксовані ретро-палітри
  /// (чорно-біла, CGA, EGA, VGA) з дизерингом.
  retroColorDepth,

  /// Для зображень: глибина кольору зростає, палітра добирається
  /// під саме зображення (median cut).
  adaptiveColorDepth,
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

  /// Біт на канал для [TargetEffectType.retroColorDepth]
  /// за поточного [progress]; null — оригінал.
  int? bitsForProgress(int progress, int steps) {
    if (progress >= steps) return null;
    final index = progress < 0 ? 0 : progress;
    return _colorDepthLevels(steps)[index];
  }

  /// Рівні в бітах на піксель, далі — оригінал.
  /// 1 крок: 1; 2 кроки: 1, 4; 3 кроки: 1, 4, 8; 4 кроки: 1, 2, 4, 8;
  /// 5+ кроків: рівні 1, 2, 4, 8 рівномірно повторюються.
  static List<int> _colorDepthLevels(int steps) {
    switch (steps) {
      case 1:
        return const [1];
      case 2:
        return const [1, 4];
      case 3:
        return const [1, 4, 8];
      case 4:
        return const [1, 2, 4, 8];
    }

    const base = [1, 2, 4, 8];
    return [for (var k = 0; k < steps; k++) base[(k * base.length) ~/ steps]];
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
