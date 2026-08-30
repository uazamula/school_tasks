import 'solution.dart';
import 'task_answer_state.dart';

class TaskResult<TAnswer, TSolution> {
  const TaskResult({required this.state, this.selectedAnswer, this.solution});

  final TaskAnswerState state;
  final TAnswer? selectedAnswer;
  final Solution<TAnswer, TSolution>? solution;

  bool get isAnswered => state != TaskAnswerState.neutral;

  bool get isCorrect => state == TaskAnswerState.correct;

  bool get isIncorrect => state == TaskAnswerState.incorrect;
}
