class AdditionTaskData {
  const AdditionTaskData({
    required this.firstNumber,
    required this.secondNumber,
  });

  final int firstNumber;
  final int secondNumber;

  int get correctAnswer => firstNumber + secondNumber;

  String get condition => '$firstNumber + $secondNumber = ?';
}
