import 'dart:math' as math;

import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';

enum TargetEffectType {
  saturation,
  glow,
  retroColorDepth,
  adaptiveColorDepth,

  /// Для зображень: відкривається колом від центру.
  circleReveal,

  /// Для зображень: розмиття зменшується з прогресом.
  blurSharpen,

  /// Для зображень: мозаїка дрібнішає з прогресом.
  mosaicSharpen,

  /// Для зображень: картинка-накривка поступово відкриває ціль.
  wipeReveal,
}

/// Як накривка відкриває ціль.
enum WipeRevealStyle {
  /// Накривка нерухома, відкрита частина росте («шторка»).
  curtain,

  /// Накривка їде разом із межею відкриття й виїжджає за край.
  slide,
}

class WipeRevealConfig {
  const WipeRevealConfig({
    required this.coverAsset,
    this.style = WipeRevealStyle.curtain,
    this.edgeSoftness = 0.08,
    this.stepDuration = const Duration(milliseconds: 400),
  }) : assert(coverAsset != ''),
       assert(edgeSoftness >= 0 && edgeSoftness <= 1);

  /// Шлях до картинки-накривки, наприклад 'assets/images/cover.png'.
  /// Масштабується під розмір цілі без зміни пропорцій (за потреби
  /// збільшується й обрізається по центру).
  final String coverAsset;

  final WipeRevealStyle style;

  /// М'якість краю як частка довжини цілі: 0 — різкий.
  /// Діє лише в режимі [WipeRevealStyle.curtain]; у режимі ковзання
  /// край накривки завжди різкий.
  final double edgeSoftness;

  /// Тривалість переходу між кроками.
  final Duration stepDuration;
}

class SharpenConfig {
  const SharpenConfig({
    this.blurStrength = 0.06,
    this.mosaicCells = 8,
    this.mosaicMaxFactor = 8,
    this.coverDim = 0.35,
    this.stepDuration = const Duration(milliseconds: 400),
  }) : assert(blurStrength >= 0),
       assert(mosaicCells >= 1),
       assert(mosaicMaxFactor >= 1),
       assert(coverDim >= 0 && coverDim <= 1);

  /// Початкова сила розмиття як частка меншої сторони картинки.
  final double blurStrength;

  /// Початкова кількість клітинок мозаїки по меншій стороні.
  final int mosaicCells;

  /// У скільки разів зростає кількість клітинок від початку до оригіналу.
  final double mosaicMaxFactor;

  /// Початкове затемнення (спільне для обох ефектів): 0 — без змін,
  /// 1 — чорна. Зменшується разом з розмиттям.
  final double coverDim;

  /// Тривалість переходу між кроками.
  final Duration stepDuration;
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
    this.sharpen = const SharpenConfig(),
    this.maxColors = 32,
    this.wipe,
  }) : assert(steps == null || steps > 0),
       assert(maxColors >= 2),
       assert(
         type != TargetEffectType.wipeReveal || wipe != null,
         'Для wipeReveal потрібно задати wipe (з coverAsset).',
       );

  /// Параметри для [TargetEffectType.wipeReveal].
  /// Значення за замовчуванням немає: coverAsset задається явно.
  final WipeRevealConfig? wipe;

  /// Для [TargetEffectType.adaptiveColorDepth]: кількість кольорів
  /// на останньому проміжному кроці (далі — оригінал).
  final int maxColors;

  /// Кількість кольорів палітри для adaptiveColorDepth; null — оригінал.
  /// Зростає геометрично від 2 до [maxColors].
  int? colorsForProgress(int progress, int steps) {
    if (progress >= steps) return null;
    if (steps == 1) return 2;

    final index = progress < 0 ? 0 : progress;
    final ratio = maxColors / 2;
    final colors = 2 * math.pow(ratio, index / (steps - 1));

    return colors.round().clamp(2, maxColors).toInt();
  }

  /// Параметри для [TargetEffectType.blurSharpen] і
  /// [TargetEffectType.mosaicSharpen].
  final SharpenConfig sharpen;

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
