import 'package:school_tasks/features/learning/domain/rational.dart';

abstract class ToleranceConfig {
  const ToleranceConfig();
}

class ExactToleranceConfig extends ToleranceConfig {
  const ExactToleranceConfig();
}

class ApproximateToleranceConfig extends ToleranceConfig {
  const ApproximateToleranceConfig({
    required this.relativeTolerance,
    required this.absoluteTolerance,
  });

  final Rational relativeTolerance;
  final Rational absoluteTolerance;
}
