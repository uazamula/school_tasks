import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/fraction_interaction.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/fraction_evaluator.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/solution.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';

class FractionTask extends LearningTask<Set<int>, int> {
  FractionTask({
    required super.prompt,
    required this.numerator,
    required this.denominator,
    required this.parts,
  }) : super(
         interaction: const FractionInteraction(),
         solution: Solution<Set<int>, int>(
           value: parts * numerator ~/ denominator,
           evaluator: const FractionEvaluator(),
         ),
       );

  final int numerator;
  final int denominator;
  final int parts;

  int get requiredSelectedParts => parts * numerator ~/ denominator;

  @override
  TaskResult<Set<int>, int> checkAnswer(Set<int> answer) {
    final isCorrect = solution.evaluate(answer);

    return TaskResult<Set<int>, int>(
      state: isCorrect ? TaskAnswerState.correct : TaskAnswerState.incorrect,
      selectedAnswer: answer,
      solution: solution,
    );
  }
}
