import 'package:school_tasks/features/learning/domain/rational.dart';
import 'package:school_tasks/features/learning/domain/task_data/input_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/math_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_mode.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/tolerance_config.dart';

final List<TaskData> roots = [
  InputTaskData(
    prompt: TaskPrompt(content: [MathContent(r'Обчисли: $\sqrt{\log_2 16}$')]),
    correctAnswer: Rational(2),
    inputMode: InputMode.decimal,
  ),
  InputTaskData(
    prompt: TaskPrompt(
      content: [MathContent(r'Обчисли: $\frac{\sqrt{25}}{5}$')],
    ),
    correctAnswer: Rational(1),
    inputMode: InputMode.decimal,
  ),
  InputTaskData(
    prompt: TaskPrompt(
      content: [
        TextContent('Знайди визначник матриці:'),
        MathContent(r'$\begin{bmatrix} 2 & 2 \\ 3 & 4 \end{bmatrix}$'),
      ],
    ),
    correctAnswer: Rational(2),
    inputMode: InputMode.decimal,
  ),

  InputTaskData(
    prompt: TaskPrompt(
      content: [
        TextContent('Скалярний добуток:'),
        TextContent('Відповідь: 1'),
        MathContent(r'$\vec{a} \cdot \vec{b} = x_1 x_2 + y_1 y_2 + z_1 z_2$'),
      ],
    ),
    correctAnswer: Rational(1),
    inputMode: InputMode.decimal,
  ),
  InputTaskData(
    prompt: TaskPrompt(
      content: [
        TextContent('Знайди x+y:'),
        MathContent(r'$\begin{cases}2x+3y=5\\4x-\ \ y=3\end{cases}$'),
      ],
    ),
    correctAnswer: Rational(2),
    inputMode: InputMode.decimal,
  ),
  InputTaskData(
    prompt: TaskPrompt(
      content: [
        TextContent('Знайди x+y:'),
        MathContent(
          r'СЛАР з ідеальним вирівнюванням знаків: '
          r'$\left\{ \begin{aligned} '
          r'2&x + 3&y &= 5 \\ '
          r'4&x - &y  &= 3 '
          r'\end{aligned} \right.$',
        ),
      ],
    ),
    correctAnswer: Rational(2),
    inputMode: InputMode.decimal,
  ),
  InputTaskData(
    prompt: TaskPrompt(
      content: [
        MathContent(
          r'Відповідь 1: Згортка: $(f*g)(t)=\int_{-\infty}^{\infty}f(\tau)g(t-\tau)\,d\tau$',
        ),
      ],
    ),
    correctAnswer: Rational(1),
    inputMode: InputMode.decimal,
  ),
  InputTaskData(
    prompt: TaskPrompt(
      content: [MathContent(r'Обчисли: $$\sqrt[3]{\int_0^2 3x^2\,dx}$$')],
    ),
    correctAnswer: Rational(2),
    inputMode: InputMode.decimal,
    tolerance: ApproximateToleranceConfig(
      relativeTolerance: Rational(1, 1000),
      absoluteTolerance: Rational(1, 10000),
    ),
  ),
];
