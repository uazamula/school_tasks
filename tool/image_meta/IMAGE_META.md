# Метадані зображень (розмір і співвідношення сторін)

Команда `images` читає розміри всіх `png` і `jpg` у `assets/images`, записує їх
у згенерований Dart-файл, а `WordFilter` використовує їх для фільтрів за
співвідношенням сторін і мінімальним розміром.

## Файли

| Файл | Куди класти | Призначення |
|---|---|---|
| `double_range.dart` | `lib/features/learning/domain/word_content/` | діапазон дробових чисел |
| `image_aspect.dart` | те саме | готові діапазони `square`, `landscape`, `portrait` |
| `image_meta.dart` | те саме | `ImageMeta` і `ImageMetaTable` (пошук розміру за шляхом) |
| `image_meta.g.dart` | те саме | **згенерований** файл (початково порожня заготовка) |
| `word_filter.dart` | те саме | замінює наявний: нові параметри фільтра |
| `image_size_reader.dart` | `tool/image_meta/` | читає розмір png/jpg із заголовка файлу |
| `image_meta_scanner.dart` | `tool/image_meta/` | обхід папки, генерація, перевірка, підсумок |
| `images_command.dart` | `tool/commands/` | команда `images` |
| `project_tools.dart` | `tool/` | замінює наявний: додано реєстрацію `ImagesCommand` |

Якщо ви змінювали `project_tools.dart` після того, як надсилали його мені,
не замінюйте файл, а додайте два рядки:

```dart
import 'commands/images_command.dart';
// ...
registry.register(() => const ImagesCommand());
```

## Команди

Усі команди запускаються з **кореня проєкту** (де лежить `pubspec.yaml`):

```
dart run tool/project_tools.dart images            # згенерувати файл + підсумок
dart run tool/project_tools.dart images --report   # лише підсумок, файл не змінюється
dart run tool/project_tools.dart images --check    # перевірити, що файл актуальний
dart run tool/project_tools.dart help              # список команд
```

Скорочення: `img` замість `images`.

- `images` обходить `assets/images`, перезаписує `image_meta.g.dart`
  і друкує підсумок.
- `images --report` показує, скільки зображень, розподіл пропорцій, скільки
  картинок менше 128 / 256 / 512 px та найменші файли. Запустіть його першим,
  щоб підібрати пороги.
- `images --check` нічого не пише. Код виходу 1, якщо є картинки без запису,
  зі зміненим розміром, видалені або непрочитні. Підходить для CI та
  перевірки перед комітом.

З Android Studio команди запускаються в Terminal (внизу вікна), а не в Run.

## Типовий порядок роботи

1. Перший раз: `images --report`, подивитися розподіл, за потреби підправити
   пороги в `image_aspect.dart`.
2. Додали або замінили картинки в `assets/images`.
3. Запустили `dart run tool/project_tools.dart images`.
4. Закомітили `image_meta.g.dart` разом із картинками.

Файл `image_meta.g.dart` не редагується вручну. Він містить `// dart format off`,
тож форматер його не змінює.

## Використання у фільтрі

```dart
filter: WordFilter(
  imageAspect: ImageAspect.square,   // майже квадратні
  minImageWidth: 256,                // не менше 256 px завширшки
  minImageHeight: 256,
)
```

- `imageAspect` приймає `ImageAspect.square`, `ImageAspect.landscape`,
  `ImageAspect.portrait` або власний діапазон:
  `DoubleRange(min: 0.75, max: 1.3)`.
- Слово без картинки або з картинкою без запису в таблиці **не проходить**
  ці правила. У воронці це видно як `пропорції зображення: 0`.
  Тоді запустіть `images`.
- Пороги `ImageAspect` орієнтовні. Уточніть їх у `image_aspect.dart`
  за підсумком `images --report`.
- Таблиця підставляється автоматично. У тестах можна передати свою:
  `filter.apply(bank, Language.uk, imageMeta: ImageMetaTable({...}))`.

## Типові проблеми

| Симптом | Причина | Що робити |
|---|---|---|
| «Directory not found: assets/images» | запуск не з кореня проєкту | `cd` у корінь і повторити |
| «Непідтримуваний формат» | у папці webp, gif, svg чи bmp | конвертувати в png/jpg |
| «Не вдалося прочитати розмір» | файл пошкоджений | перезберегти картинку |
| правило фільтра дає 0 слів | картинки немає в таблиці | запустити `images` |
| `--check` повертає код 1 | таблиця застаріла | запустити `images` і закомітити файл |

## Обмеження

- Читаються лише `png` та `jpg`/`jpeg`. Розмір береться із заголовка файлу,
  EXIF-орієнтація не враховується (для ілюстрацій це не потрібно).
- Ключ у таблиці це шлях ресурсу (`assets/images/ants.png`), як у
  `WordConcept.image`. Файли в підпапках підтримуються.
