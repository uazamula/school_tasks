import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_tasks/features/learning/data/word_content/syllable_audio_tr.dart';
import 'package:school_tasks/features/learning/data/word_content/syllable_audio_uk.dart';
import 'package:school_tasks/features/learning/data/word_content/word_bank.dart';
import 'package:school_tasks/features/learning/domain/word_content/audio_asset_listing.dart';
import 'package:school_tasks/features/learning/domain/word_content/language.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_audio_audit.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_bank.dart';

// TODO: підключіть файли з вашими даними (слова, концепти, syllableAudioUk).
//
// Приклад імпортів (шляхи замініть на свої):
//   import 'package:school_tasks/features/learning/data/.../syllable_demo_data.dart';
//   import 'package:school_tasks/features/learning/data/.../syllable_audio_uk.dart';

/// TODO: поверніть реальний банк слів.
///
/// Приклад 1. Зі старого формату (окремі списки слів і концептів):
///   WordBank _loadBank() => WordBank.fromLegacy(
///     words: syllableDemoWords,
///     concepts: syllableDemoConcepts,
///   );
///
/// Приклад 2. З нового формату (word_builder):
///   // import 'package:school_tasks/.../content_tag.dart' as t;
///   WordBank _loadBank() => WordBank([
///     wordUk('ants', 'ants', 'uk_murakhy', 'мурахи', 'му-ра-хи', {t.animal}),
///     wordUk('bark', 'bark.jpg', 'uk_kora', 'кора', 'ко-ра'),
///     words('dog', 'dog', [
///       uk('uk_pes', 'пес'),
///       en('en_dog', 'dog'),
///     ], {t.animal, t.domesticAnimal}),
///   ]);
WordBank _loadBank() => ukWordBank; //ukEnTrWordBank;

/// TODO: мапи озвучки складів за мовами.
///
/// Приклад:
///   Map<Language, Map<String, String>> _loadSyllableAudio() => {
///     Language.uk: syllableAudioUk,
///     // Language.en: syllableAudioEn,
///   };
///
/// Мапа syllableAudioUk має вигляд {'ар': 'uk_ar.mp3', 'ба': 'uk_ba.mp3', ...}.
Map<Language, Map<String, String>> _loadSyllableAudio() => {
  Language.uk: syllableAudioUk,
  Language.tr: syllableAudioTr,
};

/// Свідомі винятки з правил транслітерації (uk: 2010 рік; tr: ö→oe, ü→ue,
/// ı→ix, ç→cx, ş→sx, ğ→gx; en: без змін):
/// слово або склад → назва файлу БЕЗ мовного префікса й розширення.
/// Попередження про такі слова не показується.
///
/// Приклад (файл uk_izhak.mp3 замість uk_yizhak.mp3 за правилами):
///   const Map<String, String> _audioNameExceptions = {
///     'їжак': 'izhak',   // правило: «ї» на початку слова → yi (yizhak)
///     'юла': 'iula',     // правило: «ю» на початку слова → yu (yula)
///     'цирк': 'cyrk',    // правило: «ц» → ts, «и» → y (tsyrk)
///     'я': 'ia',         // склад «я», озвучений як «ia»
///     'köpek': 'kopek',  // турецьке: за правилами ö → oe (koepek)
///   };
///
/// Омоніми (замок, коса) називайте з суфіксом: uk_zamok.mp3, uk_zamok_2.mp3.
/// Суфікс _2, _3 дозволений і виняток для них не потрібен.
/// Ключі винятків не залежать від регістру.
const Map<String, String> _audioNameExceptions = {
  'рись': 'rysj',
  'р\'ї': 'rji',
  'рю': 'rju',
  'рюк': 'rjuk',
  'ря': 'rja',
  'ряк': 'rjak',
  'ай': 'aj',
  'дя': 'dja',
  'дю': 'dju',
  'я': 'ja',
  'як': 'jak',
  'ян': 'jan',
  'є': 'je',
  'ї': 'ji',
  'йо': 'jo',
  'ю': 'ju',
  'ля': 'lja',
  'льо': 'ljo',
  'лю': 'lju',
  'ня': 'nja',
  'ню': 'nju',
  'ой': 'oj',
  'ся': 'sja',
  'сьо': 'sjo',
  'зя': 'zja',
  'зю': 'zju',
  'яй': 'jaj',
  'м\'я': 'mja',
  'м\'яч': 'mjach',
  'ця': 'tsja',
  'чай': 'chaj',
  'міль': 'milj',
  'м\'як': 'mjak',
  "фея": "feja",
  "лисиця": "lysytsja",
  "заєць": "zajets",
  "їжак": "jizhak",
  "кінь": "kinj",
  "чайник": "chajnyk",
  "гиря": "hyrja",
  "куниця": "kunytsja",
  "м'ясо": "mjaso",
  "диня": "dynja",
  "цибуля": "tsybulja",
  "літак": "ljitak",
  "тюлень": "tjulen",
  "зозуля": "zozulja",
  "теля": "telja",
  "рюкзак": "rjukzak",
  "яблуко": "jabluko",
  "баян": "bajan",
};

/// ---------------------------------------------------------------------------
/// Як запускати
/// ---------------------------------------------------------------------------
/// 1. Папка з озвученням має бути оголошена в pubspec.yaml (зі слешем в кінці),
///    інакше список файлів буде порожнім і всі посилання стануть помилками:
///      flutter:
///        assets:
///          - assets/audio/pronunciation/
/// 2. Android Studio: відкрийте цей файл, натисніть зелений трикутник біля
///    main() або біля test(...) → Run. Або ПКМ по файлу → Run
///    'word_audio_audit_test.dart'. Тест виконується на комп'ютері, а не на
///    пристрої, емулятор не потрібен.
/// 3. Термінал:
///      flutter test test/features/learning/domain/word_content/word_audio_audit_test.dart
///    Для повного звіту без скорочень додайте --reporter expanded.
///
/// ---------------------------------------------------------------------------
/// Приклади використання тих самих інструментів в інших місцях
/// ---------------------------------------------------------------------------
/// Аудит на dev-екрані чи в довільному місці коду:
///   final files = await listPronunciationAssets();
///   final report = WordAudioAudit.run(
///     bank: bank,
///     availableFiles: files,
///     syllableAudio: {Language.uk: syllableAudioUk},
///     audioNameExceptions: _audioNameExceptions,
///   );
///   debugPrint(report.format());                          // весь звіт
///   debugPrint(report.format(only: AuditSeverity.error)); // лише помилки
///   report.errors / report.warnings / report.infos        // списки AuditIssue
///
/// Чому слово не потрапляє у вибірку генератора:
///   final reason = filter.explain(bank, Language.uk, 'ants',
///       syllableAudio: syllableAudioUk);
///   // null — слово проходить усі правила, інакше назва першого правила
///
/// Воронка без генерації завдань (теж видно в консолі при generate()):
///   final funnel = SlotAssemblyTaskDataGenerator(...).diagnose();
///   debugPrint(funnel.funnel);       // uk: 40 → теги: 12 → патерн складу: 6
///   debugPrint(funnel.rulesReport);  // окремо: теги: 12, патерн складу: 20

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('озвучка слів і складів: файли існують, назви коректні', () async {
    final files = await listPronunciationAssets(rootBundle);

    final report = WordAudioAudit.run(
      bank: _loadBank(),
      availableFiles: files,
      syllableAudio: _loadSyllableAudio(),
      audioNameExceptions: _audioNameExceptions,
    );

    debugPrint(report.format());

    // Помилки (відсутні файли) ламають тест, попередження лише друкуються.
    expect(report.errors, isEmpty, reason: report.format());
  });
}
