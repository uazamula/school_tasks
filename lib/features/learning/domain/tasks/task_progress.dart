import 'package:school_tasks/features/learning/domain/tasks/learning_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/progress_reporting_task.dart';

bool reportsOwnProgress(LearningTask<dynamic, dynamic> task) =>
    task is ProgressReportingTask;

int progressStepsOf(LearningTask<dynamic, dynamic> task) =>
    task is ProgressReportingTask
    ? (task as ProgressReportingTask).progressSteps
    : 1;

int totalProgressSteps(Iterable<LearningTask<dynamic, dynamic>> tasks) =>
    tasks.fold(0, (sum, task) => sum + progressStepsOf(task));
