import 'package:flutter/painting.dart';
import 'package:school_tasks/features/learning/domain/rational.dart';
import 'package:school_tasks/features/learning/domain/task_data/input_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/selection_button_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_mode.dart';

abstract final class CodingTasks {
  static const codingForTest = [
    // Завдання 1. Двійкове кодування
    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [TextContent('Що означає двійкове кодування інформації?')],
      ),
      correctAnswers: [
        'Подання інформації за допомогою двох символів, зазвичай 0 і 1, які використовуються для запису даних у комп’ютері.',
      ],
      wrongAnswers: [
        'Подання інформації за допомогою десяти цифр від 0 до 9, які комп’ютер безпосередньо використовує для збереження всіх даних.',
        'Перетворення тексту на зображення, щоб комп’ютер міг зберігати його у графічному форматі.',
        'Спосіб кодування, за якого кожен символ обов’язково записується трьома літерами латинського алфавіту.',
      ],
      wrongAnswerCount: 3,
      buttonConfig: SelectionButtonConfig(
        fontSize: 20,
        buttonWidth: 340,
        buttonHeight: 110,
        spacing: 12,
      ),
      requiresConfirmation: true,
    ),

    // Завдання 2. Кодування символів
    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [
          TextContent('Для чого використовують таблиці кодування символів?'),
        ],
      ),
      correctAnswers: [
        'Для встановлення відповідності між символами тексту та числовими кодами, які дають змогу комп’ютеру зберігати й обробляти текст.',
      ],
      wrongAnswers: [
        'Для автоматичного перекладу тексту з однієї мови на іншу без використання словників і програм перекладу.',
        'Для визначення швидкості роботи процесора залежно від кількості символів у текстовому документі.',
        'Для перетворення будь-якого текстового документа на набір графічних зображень без збереження його символів.',
      ],
      wrongAnswerCount: 3,
      buttonConfig: SelectionButtonConfig(
        fontSize: 17,
        buttonWidth: 280,
        buttonHeight: 130,
        spacing: 20,
      ),
    ),

    // Завдання 3. Растрове зображення
    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [
          TextContent('Як зберігається растрове зображення в комп’ютері?'),
        ],
      ),
      correctAnswers: [
        'Як набір пікселів, кожен з яких має певний колір, а кількість пікселів визначає роздільну здатність зображення.',
      ],
      wrongAnswers: [
        'Як математичний опис геометричних фігур, ліній і кривих, які можна масштабувати без втрати якості.',
        'Як послідовність звукових сигналів, у якій кожен сигнал відповідає окремому кольору зображення.',
        'Як набір текстових команд, які визначають лише назву зображення та його розміщення на екрані.',
      ],
      wrongAnswerCount: 3,
      buttonConfig: SelectionButtonConfig(
        fontSize: 16,
        buttonWidth: 400,
        buttonHeight: 150,
        spacing: 8,
        textScaler: TextScaler.noScaling,
      ),
    ),

    // Завдання 4. Стиснення даних
    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [TextContent('Яка основна мета стиснення даних?')],
      ),
      correctAnswers: [
        'Зменшити обсяг даних, необхідний для їх зберігання або передавання, використовуючи спеціальні алгоритми кодування.',
      ],
      wrongAnswers: [
        'Збільшити роздільну здатність усіх зображень і якість усіх аудіофайлів без зміни обсягу даних.',
        'Перетворити всі файли на програми, які можуть самостійно виконуватися без операційної системи.',
        'Зробити так, щоб будь-який файл займав однакову кількість пам’яті незалежно від типу та вмісту.',
      ],
      wrongAnswerCount: 3,
      buttonConfig: SelectionButtonConfig(
        fontSize: 22,
        buttonWidth: 320,
        buttonHeight: 180,
        spacing: 16,
      ),
    ),
    // multichoice
    // Завдання 1. Двійкове кодування
    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [
          TextContent(
            'Які з наведених тверджень правильно описують двійкове кодування інформації в комп’ютері?',
          ),
        ],
      ),
      correctAnswers: [
        'Для подання даних використовують два символи: 0 і 1, за допомогою яких можна закодувати різні види інформації.',
        'Один двійковий розряд може набувати одного з двох значень: 0 або 1, а послідовність таких розрядів утворює двійковий код.',
      ],
      wrongAnswers: [
        'Для кодування будь-якої інформації комп’ютер використовує лише десять цифр від 0 до 9, оскільки двійкова система призначена тільки для обчислень.',
        'Кожен символ тексту обов’язково кодується рівно двома двійковими розрядами незалежно від використаної таблиці кодування.',
        'Двійкове кодування дає змогу зберігати лише числові дані, тому для подання зображень, звуку й тексту потрібні інші системи.',
      ],
      correctAnswerCount: 2,
      wrongAnswerCount: 3,
      buttonConfig: SelectionButtonConfig(
        fontSize: 18,
        buttonWidth: 380,
        buttonHeight: 145,
        spacing: 12,
      ),
    ),

    // Завдання 2. Кодування зображень
    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [
          TextContent(
            'Які твердження правильно характеризують растрове зображення та його кодування?',
          ),
        ],
      ),
      correctAnswers: [
        'Растрове зображення складається з окремих пікселів, кожен із яких має певний колір, закодований за допомогою відповідної кількості бітів.',
        'Збільшення кількості пікселів за незмінних інших параметрів зазвичай призводить до збільшення обсягу даних, потрібних для збереження зображення.',
      ],
      wrongAnswers: [
        'Растрове зображення зберігається виключно у вигляді математичних формул, які описують геометричні фігури та дають змогу збільшувати його без втрати якості.',
        'Кожен піксель растрового зображення обов’язково має лише два можливі кольори, оскільки комп’ютер може працювати тільки з нулями та одиницями.',
        'Розмір файлу растрового зображення залежить виключно від його назви, а роздільна здатність і кількість кольорів не впливають на обсяг даних.',
      ],
      correctAnswerCount: 2,
      wrongAnswerCount: 3,
      buttonConfig: SelectionButtonConfig(
        fontSize: 16,
        buttonWidth: 420,
        buttonHeight: 160,
        spacing: 16,
        textScaler: TextScaler.noScaling,
      ),
    ),

    // Завдання 3. Кодування тексту
    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [
          TextContent(
            'Які твердження правильно пояснюють використання таблиць кодування символів у комп’ютері?',
          ),
        ],
      ),
      correctAnswers: [
        'Таблиця кодування встановлює відповідність між символами та їхніми числовими кодами, завдяки чому текст можна зберігати й обробляти у цифровому вигляді.',
        'У стандартній таблиці ASCII для представлення символів використовують 7 бітів, що дає змогу утворити 128 різних двійкових кодів.',
      ],
      wrongAnswers: [
        'Таблиця ASCII містить 256 символів у своєму стандартному семибітному варіанті, оскільки кожен символ кодується вісьмома двійковими розрядами.',
        'Кодування символів потрібне лише для англійських літер, а цифри, розділові знаки та спеціальні символи комп’ютер зберігає без числових кодів.',
        'Усі таблиці кодування символів мають однакові коди для кожного символу, тому різні стандарти кодування ніколи не спричиняють проблем із відображенням тексту.',
      ],
      correctAnswerCount: 2,
      wrongAnswerCount: 3,
      buttonConfig: SelectionButtonConfig(
        fontSize: 17,
        buttonWidth: 340,
        buttonHeight: 180,
        spacing: 10,
      ),
    ),
  ];

  static const List<TaskData> codingTasksSel = [
    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [
          TextContent(
            'Як називають кодування повідомлень з використанням лише '
            'двох сигналів (символів), які зазвичай позначають як 0 і 1',
          ),
        ],
      ),
      correctAnswers: ['Двійкове'],
      wrongAnswers: [
        'Десяткове',
        'Одиничне',
        'Вісімкове',
        'Шістнадцяткове',
        'Нульове',
      ],
      wrongAnswerCount: 3,
    ),

    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [TextContent('Скільки кодів містить таблиця кодів ASCII?')],
      ),
      correctAnswers: ['128'],
      wrongAnswers: ['2', '64', '100', '256', '65536'],
      correctAnswerCount: 1,
      wrongAnswerCount: 3,
    ),

    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [
          TextContent(
            'Яке максимальне значення інтенсивності кожного '
            'кольору в моделі RGB (десяткова система)?',
          ),
        ],
      ),
      correctAnswers: ['255'],
      wrongAnswers: ['128', '64', '100', '256', '65536'],
      correctAnswerCount: 1,
      wrongAnswerCount: 3,
    ),

    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [
          TextContent(
            'Субтрактивна колірна модель, що використовується у поліграфії',
          ),
        ],
      ),
      correctAnswers: ['CMYK'],
      wrongAnswers: ['RGB', 'JPG', 'BMP', 'WAV', 'HSV'],
      correctAnswerCount: 1,
      wrongAnswerCount: 3,
    ),

    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [
          TextContent(
            'Як називається єдина міжнародна система кодування,'
            ' що дозволяє записати символи майже всіх писемностей світу?',
          ),
        ],
      ),
      correctAnswers: ['Unicode'],
      wrongAnswers: ['ASCII', 'Windows-1251', 'KOI8-U'],
      wrongAnswerCount: 3,
    ),

    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [
          TextContent(
            'Кодувальна таблиця, у якій кожна літера тексту замінюється '
            'на координати комірки, де вона розташована',
          ),
        ],
      ),
      correctAnswers: ['Квадрат Полібія'],
      wrongAnswers: ['Шифр Цезаря', 'Азбука Морзе', 'Штрихкод'],
      wrongAnswerCount: 3,
    ),

    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [
          TextContent(
            'Як називається шифр зсуву, де кожен символ у тексті замінюється іншим символом, '
            'що стоїть у алфавіті на фіксовану кількість позицій далі',
          ),
        ],
      ),
      correctAnswers: ['Шифр Цезаря'],
      wrongAnswers: ['Квадрат Полібія', 'Азбука Морзе', 'Штрихкод'],
      wrongAnswerCount: 3,
    ),

    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [
          TextContent('Який колір у палітрі RGB відповідає HEX-коду FF0000?'),
        ],
      ),
      correctAnswers: ['🔴'],
      wrongAnswers: ['🟡', '🟢', '🔵', '🟣'],
      wrongAnswerCount: 3,
    ),

    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [
          TextContent('Який шістнадцятковий код відповідає сірому кольору?'),
        ],
      ),
      correctAnswers: ['808080', '999999', 'A1A1A1'],
      wrongAnswers: [
        'FF0000',
        '00FF00',
        '00FFFF',
        '0000FF',
        'FFFF00',
        '000000',
        'FFFFFF',
      ],
      wrongAnswerCount: 3,
    ),

    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [
          TextContent('Який шістнадцятковий код відповідає жовтому кольору?'),
        ],
      ),
      correctAnswers: ['FFFF00'],
      wrongAnswers: ['FF0000', '00FF00', '00FFFF', '0000FF', 'AAAAAA'],
      wrongAnswerCount: 3,
    ),

    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [
          TextContent('Який шістнадцятковий код відповідає білому кольору?'),
        ],
      ),
      correctAnswers: ['FFFFFF'],
      wrongAnswers: [
        'FF0000',
        '00FF00',
        '00FFFF',
        '0000FF',
        'AAAAAA',
        '000000',
      ],
      wrongAnswerCount: 3,
    ),

    SelectionTaskData<String>(
      prompt: TaskPrompt(
        content: [
          TextContent('Який шістнадцятковий код відповідає чорному кольору?'),
        ],
      ),
      correctAnswers: ['000000'],
      wrongAnswers: [
        'FF0000',
        '00FF00',
        '00FFFF',
        '0000FF',
        'AAAAAA',
        'FFFFFF',
      ],
      wrongAnswerCount: 3,
    ),
  ];
  static final List<TaskData> codingTasksInput = [
    InputTaskData(
      prompt: const TaskPrompt(
        content: [
          TextContent('Запиши десяткове число 5 у двійковій системі числення'),
        ],
      ),
      correctAnswer: Rational(101),
      inputMode: InputMode.integer,
    ),

    InputTaskData(
      prompt: const TaskPrompt(
        content: [
          TextContent('Запиши десяткове число 8 у двійковій системі числення'),
        ],
      ),
      correctAnswer: Rational(1000),
      inputMode: InputMode.integer,
    ),

    InputTaskData(
      prompt: const TaskPrompt(
        content: [
          TextContent('Запиши десяткове число 4 у двійковій системі числення'),
        ],
      ),
      correctAnswer: Rational(100),
      inputMode: InputMode.integer,
    ),

    InputTaskData(
      prompt: const TaskPrompt(
        content: [
          TextContent('Запиши десяткове число 3 у двійковій системі числення'),
        ],
      ),
      correctAnswer: Rational(11),
      inputMode: InputMode.integer,
    ),

    InputTaskData(
      prompt: const TaskPrompt(
        content: [
          TextContent(
            'Запиши число 1001 двійкової системи у десятковій системі числення',
          ),
        ],
      ),
      correctAnswer: Rational(9),
      inputMode: InputMode.integer,
    ),

    InputTaskData(
      prompt: const TaskPrompt(
        content: [
          TextContent(
            'Запиши число 11 двійкової системи у десятковій системі числення',
          ),
        ],
      ),
      correctAnswer: Rational(3),
      inputMode: InputMode.integer,
    ),

    InputTaskData(
      prompt: const TaskPrompt(
        content: [
          TextContent(
            'Запиши число 100 двійкової системи у десятковій системі числення',
          ),
        ],
      ),
      correctAnswer: Rational(4),
      inputMode: InputMode.integer,
    ),

    InputTaskData(
      prompt: const TaskPrompt(
        content: [TextContent('Скільки бітів міститься в одному байті?')],
      ),
      correctAnswer: Rational(8),
      inputMode: InputMode.integer,
    ),

    InputTaskData(
      prompt: const TaskPrompt(
        content: [TextContent('Скільки байтів міститься в одному кілобайті?')],
      ),
      correctAnswer: Rational(1024),
      inputMode: InputMode.integer,
    ),

    InputTaskData(
      prompt: const TaskPrompt(
        content: [TextContent('Скільки кБ міститься в 2 МБ?')],
      ),
      correctAnswer: Rational(2048),
      inputMode: InputMode.integer,
    ),
  ];
}
