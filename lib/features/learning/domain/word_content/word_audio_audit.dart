import 'audio_paths.dart';
import 'language.dart';
import 'ukrainian_transliteration.dart';
import 'word_bank.dart';
import 'word_text.dart';

enum AuditSeverity { error, warning, info }

enum AuditIssueCode {
  /// Файл, на який посилаються дані, відсутній серед ресурсів.
  fileMissing,

  /// У слова не задано аудіо.
  wordAudioMissing,

  /// Склад слова не має озвучки в мапі `syllableAudio`.
  syllableAudioMissing,

  /// Назва файлу не відповідає шаблону `xx_назва.mp3`.
  badAudioName,

  /// Назва файлу не збігається з транслітерацією слова чи складу.
  transliterationMismatch,

  /// Файл є в ресурсах, але ніде не використовується.
  unusedFile,
}

class AuditIssue {
  const AuditIssue({
    required this.severity,
    required this.code,
    required this.subject,
    required this.message,
  });

  final AuditSeverity severity;
  final AuditIssueCode code;

  /// Що перевірялося: id слова або склад.
  final String subject;
  final String message;

  String get _label => switch (severity) {
    AuditSeverity.error => 'ПОМИЛКА',
    AuditSeverity.warning => 'ПОПЕРЕДЖЕННЯ',
    AuditSeverity.info => 'ІНФО',
  };

  @override
  String toString() => '[$_label] $subject: $message';
}

class AuditReport {
  AuditReport(List<AuditIssue> issues) : issues = List.unmodifiable(issues);

  final List<AuditIssue> issues;

  List<AuditIssue> get errors => _bySeverity(AuditSeverity.error);
  List<AuditIssue> get warnings => _bySeverity(AuditSeverity.warning);
  List<AuditIssue> get infos => _bySeverity(AuditSeverity.info);

  bool get isClean => issues.isEmpty;

  List<AuditIssue> _bySeverity(AuditSeverity severity) => [
    for (final issue in issues)
      if (issue.severity == severity) issue,
  ];

  /// Звіт текстом: підсумок і проблеми за важливістю.
  /// [only] — показати лише цю важливість.
  String format({AuditSeverity? only}) {
    final lines = <String>[
      'Аудит озвучки: помилок ${errors.length}, '
          'попереджень ${warnings.length}, інформації ${infos.length}',
    ];

    for (final severity in AuditSeverity.values) {
      if (only != null && only != severity) continue;
      lines.addAll(_bySeverity(severity).map((i) => i.toString()));
    }

    return lines.join('\n');
  }
}

/// Перевірка озвучки слів і складів за даними та наявними файлами.
///
/// Чиста функція від даних: список файлів передається ззовні (з маніфесту
/// ресурсів застосунку чи з папки), тому логіка працює і на web.
abstract final class WordAudioAudit {
  static final RegExp _validName = RegExp(r'^[a-z0-9_]+$');

  /// [availableFiles] — повні шляхи ресурсів озвучки
  /// (`assets/audio/pronunciation/uk_ar.mp3`).
  /// [syllableAudio] — мапи «склад → файл» для кожної мови.
  /// [audioNameExceptions] — свідомі винятки: слово чи склад → дозволена
  /// назва файлу (без мовного префікса та розширення).
  static AuditReport run({
    required WordBank bank,
    required Set<String> availableFiles,
    Map<Language, Map<String, String>> syllableAudio = const {},
    Map<String, String> audioNameExceptions = const {},
  }) {
    final issues = <AuditIssue>[];
    final referenced = <String>{};

    final exceptions = {
      for (final e in audioNameExceptions.entries)
        normalizeWordKey(e.key): e.value,
    };

    // Озвучка слів.
    for (final record in bank.records) {
      for (final entry in record.entries) {
        final subject = '${record.id} (${entry.language.name})';
        final audio = entry.audio?.trim();

        if (audio == null || audio.isEmpty) {
          issues.add(
            AuditIssue(
              severity: AuditSeverity.warning,
              code: AuditIssueCode.wordAudioMissing,
              subject: subject,
              message: 'у слова "${entry.word}" не задано аудіо',
            ),
          );
          continue;
        }

        final path = AudioPaths.resolvePronunciation(audio);
        referenced.add(path);

        _checkFile(
          issues: issues,
          availableFiles: availableFiles,
          exceptions: exceptions,
          language: entry.language,
          subject: subject,
          key: entry.word,
          path: path,
          isSyllable: false,
        );
      }
    }

    // Озвучка складів.
    for (final language in _languagesOf(bank, syllableAudio)) {
      final audioMap = {
        for (final e
            in (syllableAudio[language] ?? const <String, String>{}).entries)
          normalizeWordKey(e.key): e.value.trim(),
      };

      // Склади, що використовуються словами, і слова, де вони трапляються.
      final usage = <String, List<String>>{};
      for (final record in bank.records) {
        final entry = record.entry(language);
        if (entry == null) continue;

        for (final syllable in entry.syllables) {
          final key = normalizeWordKey(syllable);
          if (key.isEmpty) continue;

          final ids = usage.putIfAbsent(key, () => []);
          if (!ids.contains(record.id)) ids.add(record.id);
        }
      }

      for (final usageEntry in usage.entries) {
        final audio = audioMap[usageEntry.key];
        if (audio != null && audio.isNotEmpty) continue;

        issues.add(
          AuditIssue(
            severity: AuditSeverity.warning,
            code: AuditIssueCode.syllableAudioMissing,
            subject: 'склад "${usageEntry.key}" (${language.name})',
            message: 'немає озвучки; слова: ${_describeIds(usageEntry.value)}',
          ),
        );
      }

      for (final audioEntry in audioMap.entries) {
        if (audioEntry.value.isEmpty) continue;

        final path = AudioPaths.resolvePronunciation(audioEntry.value);
        referenced.add(path);

        _checkFile(
          issues: issues,
          availableFiles: availableFiles,
          exceptions: exceptions,
          language: language,
          subject: 'склад "${audioEntry.key}" (${language.name})',
          key: audioEntry.key,
          path: path,
          isSyllable: true,
        );
      }
    }

    // Файли без посилань.
    final unused =
        availableFiles
            .where(
              (f) =>
                  f.startsWith(AudioPaths.pronunciationDirectory) &&
                  !referenced.contains(f),
            )
            .toList()
          ..sort();

    for (final file in unused) {
      issues.add(
        AuditIssue(
          severity: AuditSeverity.info,
          code: AuditIssueCode.unusedFile,
          subject: file,
          message: 'файл ніде не використовується',
        ),
      );
    }

    return AuditReport(issues);
  }

  static Set<Language> _languagesOf(
    WordBank bank,
    Map<Language, Map<String, String>> syllableAudio,
  ) => {
    ...syllableAudio.keys,
    for (final record in bank.records)
      for (final entry in record.entries)
        if (entry.syllables.isNotEmpty) entry.language,
  };

  static String _describeIds(List<String> ids) {
    const limit = 3;
    if (ids.length <= limit) return ids.join(', ');
    return '${ids.take(limit).join(', ')} (+${ids.length - limit})';
  }

  /// Перевіряє наявність файлу та його назву.
  static void _checkFile({
    required List<AuditIssue> issues,
    required Set<String> availableFiles,
    required Map<String, String> exceptions,
    required Language language,
    required String subject,
    required String key,
    required String path,
    required bool isSyllable,
  }) {
    if (!availableFiles.contains(path)) {
      issues.add(
        AuditIssue(
          severity: AuditSeverity.error,
          code: AuditIssueCode.fileMissing,
          subject: subject,
          message: 'файл не знайдено: $path',
        ),
      );
      return;
    }

    final fileName = path.split('/').last;
    final dot = fileName.lastIndexOf('.');
    final name = dot < 0 ? fileName : fileName.substring(0, dot);
    final extension = dot < 0 ? '' : fileName.substring(dot + 1);
    final prefix = '${language.name}_';

    if (!_validName.hasMatch(name) ||
        extension != 'mp3' ||
        !name.startsWith(prefix)) {
      issues.add(
        AuditIssue(
          severity: AuditSeverity.warning,
          code: AuditIssueCode.badAudioName,
          subject: subject,
          message:
              'некоректна назва "$fileName": очікується ${prefix}назва.mp3 '
              '(малі латинські літери, цифри та "_")',
        ),
      );
      return;
    }

    // Транслітерацію перевіряємо лише для української.
    if (language != Language.uk) return;

    final base = name.substring(prefix.length);
    final normalizedKey = normalizeWordKey(key);

    if (exceptions[normalizedKey] == base) return;

    if (!_matchesTransliteration(normalizedKey, base, isSyllable: isSyllable)) {
      final expected = UkrainianTransliteration.transliterate(normalizedKey);
      issues.add(
        AuditIssue(
          severity: AuditSeverity.warning,
          code: AuditIssueCode.transliterationMismatch,
          subject: subject,
          message:
              '"$key" за правилами 2010 року → "$expected", '
              'а у файлі "$base"',
        ),
      );
    }
  }

  /// Назва збігається з транслітерацією (допускається суфікс `_2`, `_3`
  /// для омонімів). Для складів приймаються обидва варіанти першої літери:
  /// як на початку слова та всередині.
  static bool _matchesTransliteration(
    String key,
    String base, {
    required bool isSyllable,
  }) {
    final candidates = {
      UkrainianTransliteration.transliterate(key),
      if (isSyllable)
        UkrainianTransliteration.transliterate(key, initial: false),
    }..remove('');

    // Нічого перевіряти (наприклад, слово не кирилицею).
    if (candidates.isEmpty) return true;

    for (final candidate in candidates) {
      if (base == candidate) return true;

      if (RegExp('^${RegExp.escape(candidate)}_\\d+\$').hasMatch(base)) {
        return true;
      }
    }

    return false;
  }
}
