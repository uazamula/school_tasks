import 'learning_task.dart';
import 'task_answer_state.dart';
import 'task_result.dart';

class ChoiceTask extends LearningTask {
  const ChoiceTask({
    required super.condition,
    required super.correctAnswer,
    required this.answers,
  });

  final List<int> answers;

  @override
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
