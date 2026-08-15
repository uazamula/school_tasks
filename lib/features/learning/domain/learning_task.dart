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

  bool isCorrect(int answer) => answer == correctAnswer;
}
