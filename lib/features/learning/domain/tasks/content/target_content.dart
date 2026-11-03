import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';

enum TargetEffectType {
  saturation,
  glow,
  retroColorDepth,
  adaptiveColorDepth,

  /// Для зображень: відкривається колом від центру.
  circleReveal,
}

/// Що видно поза колом.
enum CircleRevealCover { blur, mosaic }

class CircleRevealConfig {
  const CircleRevealConfig({
    this.cover = CircleRevealCover.blur,
    this.blurStrength = 0.025,
    this.mosaicCells = 16,
    this.coverDim = 0.2,
    this.edgeSoftness = 0.12,
    this.stepDuration = const Duration(milliseconds: 400),
    this.finalDurationFactor = 0.8,
  }) : assert(blurStrength >= 0),
       assert(mosaicCells >= 1),
       assert(coverDim >= 0 && coverDim <= 1),
       assert(edgeSoftness >= 0 && edgeSoftness <= 1),
       assert(finalDurationFactor >= 0);

  // Параметр	            Що змінює	                            Початкове	Що пробувати
  // cover	              розмиття чи мозаїка	                    blur	  mosaic
  // blurStrength	        сила розмиття (частка меншої сторони)	  0.05	  0.03–0.10
  // mosaicCells	        клітинок по меншій стороні;
  //                      менше — грубіше	                        12	    6–20
  // coverDim	            затемнення прихованої частини	          0.35	  0 — без затемнення, 0.6 — майже силует
  // edgeSoftness	        м'якість краю	                          0.12	  0 — різкий, 0.4 — дуже м'який
  // stepDuration	        тривалість проміжних кроків	            400 мс	250–600 мс
  // finalDurationFactor	частка feedbackDuration для фіналу	    0.8	    0.5–1.0
  /// Розмиття чи мозаїка поза колом.
  final CircleRevealCover cover;

  /// Сила розмиття як частка меншої сторони картинки
  /// (0.05 ≈ 5 %; не залежить від роздільності файлу).
  final double blurStrength;

  /// Скільки клітинок мозаїки вміщується по меншій стороні.
  final int mosaicCells;

  /// Затемнення прихованої частини: 0 — без змін, 1 — чорна.
  final double coverDim;

  /// М'якість краю кола: 0 — різкий, 1 — дуже м'який.
  final double edgeSoftness;

  /// Тривалість проміжних кроків.
  final Duration stepDuration;

  /// Частка від feedbackDuration, за яку відбувається фінальне розкриття.
  final double finalDurationFactor;
}

class TargetEffectConfig {
  const TargetEffectConfig({
    this.type = TargetEffectType.saturation,
    this.steps,
    this.reveal = const CircleRevealConfig(),
  }) : assert(steps == null || steps > 0);

  /// Параметри для [TargetEffectType.circleReveal].
  final CircleRevealConfig reveal;

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
