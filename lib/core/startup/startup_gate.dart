import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/config/app_config.dart';
import 'package:school_tasks/core/startup/app_ready_provider.dart';
import 'package:school_tasks/core/theme/app_colors.dart';
import 'package:school_tasks/features/learning/domain/evaluation/visual_grade_scale.dart';

/// Показує сплеш при старті, поки не завантажаться налаштування,
/// не прогріються зображення і не мине мінімальний час.
class StartupGate extends ConsumerStatefulWidget {
  const StartupGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends ConsumerState<StartupGate> {
  bool _minTimePassed = false;
  bool _imagesReady = false;
  bool _precacheStarted = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(AppConfig.splashMinDuration, () {
      if (mounted) setState(() => _minTimePassed = true);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_precacheStarted) {
      _precacheStarted = true;
      _precacheImages();
    }
  }

  /// Прогрів зображень візуальної шкали, щоб вони не мигали при першому показі.
  Future<void> _precacheImages() async {
    final assets = VisualGradeScale.levels
        .map((level) => level.imageAsset)
        .whereType<String>();

    for (final asset in assets) {
      try {
        await precacheImage(AssetImage(asset), context);
      } catch (_) {
        // Відсутнє зображення не повинно блокувати запуск.
      }

      if (!mounted) return;
    }

    setState(() => _imagesReady = true);
  }

  @override
  Widget build(BuildContext context) {
    final settingsReady = !ref.watch(appReadyProvider).isLoading;
    final showSplash = !(settingsReady && _imagesReady && _minTimePassed);

    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !showSplash,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: showSplash
                  ? const _SplashScreen()
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
}

/// Сплеш не залежить від теми застосунку, тому кольори задані явно.
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  static const _background = Color(0xFFFFF8EE);
  static const _textColor = Color(0xFF3B3B3B);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              AppConfig.splashIcon,
              size: 112,
              color: AppColors.gentleSeed,
            ),            const SizedBox(height: 16),
            const Text(
              AppConfig.splashTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 240,
              // Смужка заповнюється за мінімальний час показу.
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: AppConfig.splashMinDuration,
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(6),
                  color: AppColors.gentleSeed,
                  backgroundColor: AppColors.gentleSeed.withValues(alpha: 0.2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              AppConfig.splashHint,
              style: TextStyle(fontSize: 16, color: _textColor),
            ),
          ],
        ),
      ),
    );
  }
}
