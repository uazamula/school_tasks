import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';

class AudioPlaybackController {
  Future<void> Function()? _togglePlayback;

  void attach(Future<void> Function() callback) {
    _togglePlayback = callback;
  }

  void detach(Future<void> Function() callback) {
    if (identical(_togglePlayback, callback)) {
      _togglePlayback = null;
    }
  }

  void toggle() {
    final callback = _togglePlayback;

    if (callback != null) {
      unawaited(callback());
    }
  }

  void dispose() {
    _togglePlayback = null;
  }
}

class TaskAudioWidget extends StatefulWidget {
  const TaskAudioWidget({
    super.key,
    required this.content,
    this.isActive = false,
    this.iconColor,
    this.interactive = true,
    this.child,
    this.showIcon = true,
    this.onCompleted,
    this.controller,
  });

  final AudioContent content;
  final VoidCallback? onCompleted;

  /// true — аудіо запускається натисканням на віджет.
  /// false — натисканням керує зовнішній віджет або controller.
  final bool interactive;

  /// Керує відтворенням ззовні.
  final bool isActive;

  final Color? iconColor;
  final Widget? child;
  final bool showIcon;
  final AudioPlaybackController? controller;

  @override
  State<TaskAudioWidget> createState() => _TaskAudioWidgetState();
}

class _TaskAudioWidgetState extends State<TaskAudioWidget> {
  late final AudioPlayer _player;

  late final Future<void> Function() _controllerCallback;

  PlayerState _playerState = PlayerState.stopped;
  String? _currentAudioPath;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();
    _controllerCallback = () => _togglePlayback(force: true);

    widget.controller?.attach(_controllerCallback);

    _player.onPlayerStateChanged.listen((state) {
      debugPrint('AUDIO EVENT: state=$state');

      if (mounted) {
        setState(() {
          _playerState = state;
        });
      }
    });

    _player.onPlayerComplete.listen((_) {
      debugPrint('AUDIO EVENT: completed');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final audioPath = _resolveAudioPath();

    if (_currentAudioPath != null && _currentAudioPath != audioPath) {
      unawaited(_stop());
    }

    _currentAudioPath = audioPath;
  }

  @override
  void didUpdateWidget(covariant TaskAudioWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.detach(_controllerCallback);
      widget.controller?.attach(_controllerCallback);
    }

    final oldPath = _resolveAudioPathFor(oldWidget.content);
    final newPath = _resolveAudioPath();

    if (oldPath != newPath) {
      unawaited(_stop());
    }

    _currentAudioPath = newPath;

    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        unawaited(_play());
      } else {
        unawaited(_stop());
      }
    }
  }

  @override
  void dispose() {
    debugPrint('AUDIO: widget disposed');
    widget.controller?.detach(_controllerCallback);
    unawaited(_player.dispose());
    super.dispose();
  }

  Future<void> _togglePlayback({bool force = false}) async {
    debugPrint('AUDIO: toggle started, state=$_playerState');

    if (!widget.interactive && !force) {
      debugPrint('AUDIO: interaction disabled');
      return;
    }

    final audioPath = _resolveAudioPath();
    debugPrint('AUDIO: path=$audioPath');

    if (audioPath == null || audioPath.trim().isEmpty) {
      debugPrint('AUDIO: path is empty');
      return;
    }

    _currentAudioPath = audioPath;

    switch (_playerState) {
      case PlayerState.playing:
      case PlayerState.paused:
        debugPrint('AUDIO: stopping');
        await _player.stop();
        break;

      case PlayerState.stopped:
      case PlayerState.completed:
        debugPrint('AUDIO: starting playback');
        await _player.play(AssetSource(_assetPath(audioPath)));
        debugPrint('AUDIO: playback started');
        break;

      case PlayerState.disposed:
        debugPrint('AUDIO: player disposed');
        return;
    }
  }

  Future<void> _play() async {
    final audioPath = _resolveAudioPath();

    if (audioPath == null || audioPath.trim().isEmpty) {
      return;
    }

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

    if (widget.child != null) {
      final child = widget.child!;

      // Зовнішній віджет керує натисканням.
      if (!widget.interactive) {
        return child;
      }

      final colorScheme = Theme.of(context).colorScheme;

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _togglePlayback(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isPlaying ? colorScheme.primaryContainer : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),
      );
    }

    if (!widget.showIcon) {
      return const SizedBox.shrink();
    }

    final iconColor =
        widget.iconColor ?? Theme.of(context).colorScheme.onSurface;

    final icon = Icon(
      isPlaying ? Icons.stop : Icons.play_arrow,
      color: iconColor,
      size: 32,
    );

    if (!widget.interactive) {
      return icon;
    }

    return IconButton.filled(
      onPressed: _resolveAudioPath() == null ? null : () => _togglePlayback(),
      icon: icon,
      tooltip: isPlaying ? 'Зупинити' : 'Відтворити',
    );
  }
}
