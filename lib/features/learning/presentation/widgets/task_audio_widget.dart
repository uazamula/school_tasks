import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';

class TaskAudioWidget extends StatefulWidget {
  const TaskAudioWidget({
    super.key,
    required this.content,
    this.isActive = false,
    this.iconColor,
  });

  final AudioContent content;

  /// Використовується для AudioAnswerButton.
  ///
  /// true  → аудіо має відтворюватися.
  /// false → аудіо має бути зупинене.
  ///
  /// Для звичайного аудіо в prompt залишається false.
  final bool isActive;

  final Color? iconColor;

  @override
  State<TaskAudioWidget> createState() => _TaskAudioWidgetState();
}

class _TaskAudioWidgetState extends State<TaskAudioWidget> {
  late final AudioPlayer _player;

  PlayerState _playerState = PlayerState.stopped;
  String? _currentAudioPath;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();

    _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;

      setState(() {
        _playerState = state;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final audioPath = _resolveAudioPath();

    if (_currentAudioPath != null && _currentAudioPath != audioPath) {
      _stop();
    }

    _currentAudioPath = audioPath;
  }

  @override
  void didUpdateWidget(covariant TaskAudioWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldPath = _resolveAudioPathFor(oldWidget.content);
    final newPath = _resolveAudioPath();

    if (oldPath != newPath) {
      _stop();
    }

    _currentAudioPath = newPath;

    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        _play();
      } else {
        _stop();
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _play() async {
    final audioPath = _resolveAudioPath();

    if (audioPath == null) return;

    _currentAudioPath = audioPath;

    await _player.play(AssetSource(_assetPath(audioPath)));
  }

  Future<void> _stop() async {
    await _player.stop();

    if (!mounted) return;

    setState(() {
      _playerState = PlayerState.stopped;
    });
  }

  String? _resolveAudioPath() {
    return _resolveAudioPathFor(widget.content);
  }

  String? _resolveAudioPathFor(AudioContent content) {
    final fixedPath = content.audioPath;

    if (fixedPath != null) {
      return fixedPath;
    }

    final localizedPaths = content.localizedPaths;

    if (localizedPaths == null) {
      return null;
    }

    final languageCode = Localizations.localeOf(context).languageCode;

    return localizedPaths[languageCode] ?? localizedPaths['uk'];
  }

  String _assetPath(String path) {
    const prefix = 'assets/';

    if (path.startsWith(prefix)) {
      return path.substring(prefix.length);
    }

    return path;
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _playerState == PlayerState.playing;

    final color = widget.iconColor ?? Theme.of(context).colorScheme.onSurface;

    return Icon(
      isPlaying ? Icons.stop : Icons.play_arrow,
      color: color,
      size: 32,
    );
  }
}
