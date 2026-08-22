import 'learning_task.dart';
import 'task_answer_state.dart';
import 'task_result.dart';

class MultiChoiceTask extends LearningTask<List<String>> {
  const MultiChoiceTask({
    required super.condition,
    required this.imagePath,
    required this.answers,
    required this.correctAnswers,
  });

  final String imagePath;
  final List<String> answers;
  final List<String> correctAnswers;

  @override
  TaskResult<List<String>> checkAnswer(List<String> answer) {
    final selectedAnswers = Set<String>.from(answer);
    final expectedAnswers = Set<String>.from(correctAnswers);

    final isCorrect =
        selectedAnswers.length == expectedAnswers.length &&
        selectedAnswers.containsAll(expectedAnswers);

    return TaskResult<List<String>>(
      state: isCorrect ? TaskAnswerState.correct : TaskAnswerState.incorrect,
      selectedAnswer: answer,
      correctAnswer: correctAnswers,
    );
  }
}
