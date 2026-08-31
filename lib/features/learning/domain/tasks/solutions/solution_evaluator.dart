abstract class SolutionEvaluator<TAnswer, TSolution> {
  const SolutionEvaluator();

  bool evaluate(TAnswer answer, TSolution solution);
}
