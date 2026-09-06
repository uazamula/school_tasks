import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_answer.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/matching_evaluator.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/solution.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/matching_interaction.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';

class MatchingTask extends LearningTask<MatchingAnswer, List<MatchingPair>> {
  MatchingTask({required super.prompt, required this.pairs})
    : super(
        interaction: const MatchingInteraction(),
        solution: Solution<MatchingAnswer, List<MatchingPair>>(
          value: pairs,
          evaluator: const MatchingEvaluator(),
        ),
      );

  /// Пари, відібрані для конкретного завдання.
  final List<MatchingPair> pairs;

  @override
  TaskResult<MatchingAnswer, List<MatchingPair>> checkAnswer(
    MatchingAnswer answer,
  ) {
    final isCorrect = solution.evaluate(answer);

    return TaskResult<MatchingAnswer, List<MatchingPair>>(
      state: isCorrect ? TaskAnswerState.correct : TaskAnswerState.incorrect,
      selectedAnswer: answer,
      solution: solution,
    );
  }
}
