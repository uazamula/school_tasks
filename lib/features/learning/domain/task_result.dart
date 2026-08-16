import 'task_answer_state.dart';

class TaskResult<TAnswer> {
  const TaskResult({
    required this.state,
    this.selectedAnswer,
    this.correctAnswer,
  });

  final TaskAnswerState state;
  final TAnswer? selectedAnswer;
  final TAnswer? correctAnswer;

  bool get isAnswered => state != TaskAnswerState.neutral;

  bool get isCorrect => state == TaskAnswerState.correct;

  bool get isIncorrect => state == TaskAnswerState.incorrect;
}
