import 'package:flutter/services.dart';

import 'audio_paths.dart';

/// Повні шляхи всіх файлів озвучки з маніфесту ресурсів застосунку.
/// Працює і на web, і в `flutter test` (ресурси беруться з pubspec).
Future<Set<String>> listPronunciationAssets([AssetBundle? bundle]) async {
  final manifest = await AssetManifest.loadFromAssetBundle(
    bundle ?? rootBundle,
  );

  return {
    for (final key in manifest.listAssets())
      if (key.startsWith(AudioPaths.pronunciationDirectory)) key,
  };
}
