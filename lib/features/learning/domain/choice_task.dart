import 'learning_task.dart';
import 'selection_interaction.dart';
import 'task_answer_state.dart';
import 'task_result.dart';

class ChoiceTask extends LearningTask<int> {
  const ChoiceTask({
    required super.prompt,
    required this.correctAnswer,
    required this.answers,
  }) : super(
         interaction: const SelectionInteraction(mode: SelectionMode.single),
       );

  final int correctAnswer;
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
