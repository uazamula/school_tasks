class AdditionGeneratorConfig {
  const AdditionGeneratorConfig({
    required this.minA,
    required this.maxA,
    required this.minB,
    required this.maxB,
    required this.minimumResult,
    required this.maximumResult,
    this.wrongAnswerCount = 3,
  });

  final int minA;
  final int maxA;

  final int minB;
  final int maxB;

  final int minimumResult;
  final int maximumResult;

  final int wrongAnswerCount;
}
