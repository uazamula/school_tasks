import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'audio_service.dart';

part 'audio_service_provider.g.dart';

@Riverpod(keepAlive: true)
AudioService audioService(AudioServiceRef ref) {
  final service = AudioService();

  ref.onDispose(() {
    service.dispose();
  });

  return service;
}
