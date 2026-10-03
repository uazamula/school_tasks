import 'package:school_tasks/features/learning/domain/rational.dart';
import 'package:school_tasks/features/learning/domain/task_data/input_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_mode.dart';

abstract final class CodingTasks {
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
