import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';

class TaskAudioWidget extends StatefulWidget {
  const TaskAudioWidget({super.key, required this.content});

  final AudioContent content;

  @override
  State<TaskAudioWidget> createState() => _TaskAudioWidgetState();
}

class _TaskAudioWidgetState extends State<TaskAudioWidget> {
  late final AudioPlayer _player;

  PlayerState _playerState = PlayerState.stopped;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();

    _player.onPlayerStateChanged.listen((state) {
      if (!mounted) {
        return;
      }

      setState(() {
        _playerState = state;
      });
    });
  }

  @override
  void didUpdateWidget(covariant TaskAudioWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.content.audioPath != widget.content.audioPath) {
      _stop();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlayback() async {
    switch (_playerState) {
      case PlayerState.playing:
        await _player.pause();

      case PlayerState.paused:
        await _player.resume();

      case PlayerState.stopped:
      case PlayerState.completed:
        await _player.play(AssetSource(_assetPath(widget.content.audioPath)));
      case PlayerState.disposed:
        return;
    }
  }

  Future<void> _stop() async {
    await _player.stop();

    if (!mounted) {
      return;
    }

    setState(() {
      _playerState = PlayerState.stopped;
    });
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

    return IconButton.filled(
      onPressed: _togglePlayback,
      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
      tooltip: isPlaying ? 'Пауза' : 'Відтворити',
    );
  }
}
