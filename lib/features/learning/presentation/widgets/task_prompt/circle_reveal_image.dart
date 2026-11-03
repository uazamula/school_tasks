import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/target_content.dart';

/// Зображення, що відкривається колом від центру.
///
/// [stage]: 0 — приховано; 0…1 — діаметр кола як частка меншої сторони;
/// 1…2 — коло росте від меншої сторони до описаного навколо картинки;
/// 2 — відкрито повністю.
class CircleRevealImage extends StatelessWidget {
  const CircleRevealImage({
    super.key,
    required this.assetPath,
    required this.stage,
    required this.config,
    required this.duration,
  });

  final String assetPath;
  final double stage;
  final CircleRevealConfig config;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: stage),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        final isOpen = value >= 2 - 1e-3;

        // Center дає Stack «вільні» обмеження, тож він стискається до
        // розміру чіткої картинки (BoxFit.contain, пропорції збережені).
        // Розмитий шар і маска кола мають той самий розмір і центр.
        return Center(
          child: Stack(
            children: [
              // Нижній шар: розмита або мозаїчна версія. Коли картинка
              // відкрита повністю, шар прибирається.
              Positioned.fill(
                child: Visibility(
                  visible: !isOpen,
                  // dstOut: нижній шар видно лише ПОЗА колом, тож
                  // крізь напівпрозорі краї чіткої картинки він не просвічує.
                  child: ShaderMask(
                    blendMode: BlendMode.dstOut,
                    shaderCallback: (bounds) => _maskShader(bounds, value),
                    child: _buildCover(),
                  ),
                ),
              ),
              // Верхній шар: чітка картинка, видима лише в колі.
              // Саме він задає розмір Stack.
              ShaderMask(
                blendMode: BlendMode.dstIn,
                shaderCallback: (bounds) => _maskShader(bounds, value),
                child: Image.asset(assetPath, fit: BoxFit.contain),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCover() {
    // RepaintBoundary: шар статичний і не перемальовується
    // на кожному кадрі анімації кола.
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          if (!size.isFinite || size.isEmpty) return const SizedBox.shrink();

          final shortest = size.shortestSide;

          final Widget image = switch (config.cover) {
            CircleRevealCover.blur => _blurred(shortest * config.blurStrength),
            CircleRevealCover.mosaic => _mosaic(size, shortest),
          };

          final dim = config.coverDim;
          if (dim <= 0) return image;

          final k = 1 - dim;
          return ColorFiltered(
            colorFilter: ColorFilter.matrix(<double>[
              k, 0, 0, 0, 0, //
              0, k, 0, 0, 0, //
              0, 0, k, 0, 0, //
              0, 0, 0, 1, 0,
            ]),
            child: image,
          );
        },
      ),
    );
  }

  Widget _blurred(double sigma) {
    final image = Image.asset(assetPath, fit: BoxFit.fill);
    if (sigma < 0.01) return image;

    // ClipRect: розмиття не виходить за межі картинки.
    return ClipRect(
      child: ImageFiltered(
        imageFilter: ui.ImageFilter.blur(
          sigmaX: sigma,
          sigmaY: sigma,
          tileMode: TileMode.clamp,
        ),
        child: image,
      ),
    );
  }

  Widget _mosaic(Size size, double shortest) {
    final cell = shortest / config.mosaicCells;
    final columns = math.max(1, (size.width / cell).round());
    final rows = math.max(1, (size.height / cell).round());

    // Декодуємо в малому розмірі й розтягуємо без згладжування.
    return Image.asset(
      assetPath,
      fit: BoxFit.fill,
      cacheWidth: columns,
      cacheHeight: rows,
      filterQuality: FilterQuality.none,
    );
  }

  Shader _maskShader(Rect bounds, double stage) {
    const solid = Color(0xFFFFFFFF);
    const clear = Color(0x00FFFFFF);

    final shortest = bounds.shortestSide;

    // Приховано: маска повністю прозора.
    if (stage <= 0.001 || shortest <= 0) {
      return const LinearGradient(colors: [clear, clear]).createShader(bounds);
    }

    final softness = config.edgeSoftness.clamp(0.0, 1.0).toDouble();
    final diagonal = math.sqrt(
      bounds.width * bounds.width + bounds.height * bounds.height,
    );

    // Діаметр (у частках меншої сторони), за якого внутрішній край
    // м'якої смуги вже виходить за кути картинки.
    final fullDiameter = diagonal / shortest / (1 - softness / 2);

    final diameter = stage <= 1 ? stage : 1 + (stage - 1) * (fullDiameter - 1);

    final radius = diameter / 2;
    final outer = radius * (1 + softness / 2);
    final inner = math.min((1 - softness / 2) / (1 + softness / 2), 0.9999);

    return RadialGradient(
      center: Alignment.center,
      radius: outer, // частка меншої сторони
      colors: const [solid, solid, clear],
      stops: [0, inner, 1],
    ).createShader(bounds);
  }
}
