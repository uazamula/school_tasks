import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';

class AudioContent extends TaskContent {
  const AudioContent._({this.audioPath, this.localizedPaths});

  const AudioContent.fixed(String path) : this._(audioPath: path);

  const AudioContent.localized(Map<String, String> paths)
    : this._(localizedPaths: paths);

  final String? audioPath;
  final Map<String, String>? localizedPaths;

  bool get isLocalized => localizedPaths != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! AudioContent) {
      return false;
    }

    if (audioPath != other.audioPath) {
      return false;
    }

    final otherPaths = other.localizedPaths;

    if (localizedPaths == null || otherPaths == null) {
      return localizedPaths == otherPaths;
    }

    if (localizedPaths!.length != otherPaths.length) {
      return false;
    }

    for (final entry in localizedPaths!.entries) {
      if (otherPaths[entry.key] != entry.value) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode {
    if (audioPath != null) {
      return audioPath.hashCode;
    }

    final paths = localizedPaths!;

    final entries = paths.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Object.hashAll(
      entries.map((entry) => Object.hash(entry.key, entry.value)),
    );
  }
}
