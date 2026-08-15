import 'task_answer_state.dart';
import 'task_result.dart';

class LearningTask {
  const LearningTask({
    required this.firstNumber,
    required this.secondNumber,
    required this.correctAnswer,
    required this.answers,
  });

  final int firstNumber;
  final int secondNumber;
  final int correctAnswer;
  final List<int> answers;

  TaskResult<int> checkAnswer(int answer) {
    return TaskResult<int>(
      state: answer == correctAnswer
          ? TaskAnswerState.correct
          : TaskAnswerState.incorrect,
      selectedAnswer: answer,
      correctAnswer: correctAnswer,
    );
  }
}
