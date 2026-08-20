class TaskData {
  const TaskData({
    required this.condition,
    required this.correctAnswer,
    this.answers,
  });

  final String condition;
  final int correctAnswer;
  final List<int>? answers;

  TaskData copyWith({
    String? condition,
    int? correctAnswer,
    List<int>? answers,
  }) {
    return TaskData(
      condition: condition ?? this.condition,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      answers: answers ?? this.answers,
    );
  }
}
