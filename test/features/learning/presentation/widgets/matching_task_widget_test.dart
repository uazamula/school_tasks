import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_tasks/features/learning/domain/evaluation/accuracy_result.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_answer.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/tasks/matching_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';
import 'package:school_tasks/features/learning/presentation/widgets/matching/matching_column.dart';
import 'package:school_tasks/features/learning/presentation/widgets/matching_task_widget.dart';

/// Збирає виклики колбеків віджета.
class _Harness {
  int progressSteps = 0;
  int correctPairs = 0;
  int incorrectPairs = 0;
  AccuracyResult? accuracy;
  TaskResult<MatchingAnswer, List<MatchingPair>>? result;
}

MatchingTask _task(List<(String, String)> pairs) {
  return MatchingTask(
    prompt: const TaskPrompt(content: [TextContent('Зістав елементи')]),
    pairs: [
      for (final (left, right) in pairs)
        MatchingPair(left: TextContent(left), right: TextContent(right)),
    ],
  );
}

Future<_Harness> _pump(WidgetTester tester, MatchingTask task) async {
  final harness = _Harness();

  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: MatchingTaskWidget(
              task: task,
              result: null,
              onTaskAnswered: (r) => harness.result = r,
              onProgressStep: () => harness.progressSteps++,
              onCorrectPair: () => harness.correctPairs++,
              feedbackEnabled: true,
              onIncorrectPair: () => harness.incorrectPairs++,
              onIncorrectPairAttempt: () => false,
              onAccuracyChanged: (a) => harness.accuracy = a,
            ),
          ),
        ),
      ),
    ),
  );

  return harness;
}

Future<void> _tap(
  WidgetTester tester, {
  required bool left,
  required int index,
}) async {
  await tester.tap(
    find.byKey(MatchingColumn.itemKey(isLeft: left, index: index)),
  );
  await tester.pump();
}

bool _isVisible(WidgetTester tester, {required bool left, required int index}) {
  return tester
      .widget<Visibility>(
        find.byKey(MatchingColumn.itemKey(isLeft: left, index: index)),
      )
      .visible;
}

void main() {
  group('MatchingTaskWidget: дублікати', () {
    testWidgets('дублікат з правої сторони: зникає натиснутий елемент', (
      tester,
    ) async {
      // pair0 = ('2*3', '6'), pair1 = ('3*2', '6')
      final harness = await _pump(tester, _task([('2*3', '6'), ('3*2', '6')]));

      // Лівий '2*3' (індекс 0) і права шістка з рядка pair1 (індекс 1).
      await _tap(tester, left: true, index: 0);
      await _tap(tester, left: false, index: 1);

      expect(_isVisible(tester, left: true, index: 0), isFalse);
      expect(_isVisible(tester, left: false, index: 1), isFalse);

      // Інша шістка і лівий '3*2' лишилися.
      expect(_isVisible(tester, left: false, index: 0), isTrue);
      expect(_isVisible(tester, left: true, index: 1), isTrue);

      expect(harness.progressSteps, 1);
      expect(harness.result, isNull);

      // Решта елементів також утворює правильну пару.
      await _tap(tester, left: true, index: 1);
      await _tap(tester, left: false, index: 0);
      await tester.pump();

      expect(harness.progressSteps, 2);
      expect(harness.result?.state, TaskAnswerState.correct);
      expect(harness.result?.accuracy?.correct, 2);
    });

    testWidgets('дублікат з лівої сторони: зникає натиснутий елемент', (
      tester,
    ) async {
      // pair0 = ('ло', 'сало'), pair1 = ('ло', 'мило')
      final harness = await _pump(
        tester,
        _task([('ло', 'сало'), ('ло', 'мило')]),
      );

      // Другий 'ло' (індекс 1) із 'сало' (індекс 0).
      await _tap(tester, left: true, index: 1);
      await _tap(tester, left: false, index: 0);

      expect(_isVisible(tester, left: true, index: 1), isFalse);
      expect(_isVisible(tester, left: false, index: 0), isFalse);
      expect(_isVisible(tester, left: true, index: 0), isTrue);
      expect(_isVisible(tester, left: false, index: 1), isTrue);

      // Лишилася пара 'ло' — 'мило'.
      await _tap(tester, left: true, index: 0);
      await _tap(tester, left: false, index: 1);
      await tester.pump();

      expect(harness.progressSteps, 2);
      expect(harness.result?.state, TaskAnswerState.correct);
    });
  });

  group('MatchingTaskWidget: помилки та точність', () {
    testWidgets('неправильна спроба нічого не ховає', (tester) async {
      final harness = await _pump(tester, _task([('a', '1'), ('b', '2')]));

      await _tap(tester, left: true, index: 0);
      await _tap(tester, left: false, index: 1);

      expect(harness.incorrectPairs, 1);
      expect(harness.progressSteps, 0);

      for (final index in [0, 1]) {
        expect(_isVisible(tester, left: true, index: index), isTrue);
        expect(_isVisible(tester, left: false, index: index), isTrue);
      }
    });

    testWidgets('точність: помилка перед правильною спробою не зараховується', (
      tester,
    ) async {
      final harness = await _pump(tester, _task([('a', '1'), ('b', '2')]));

      // 'a' — спершу помилка, потім правильно.
      await _tap(tester, left: true, index: 0);
      await _tap(tester, left: false, index: 1);
      await _tap(tester, left: true, index: 0);
      await _tap(tester, left: false, index: 0);

      // 'b' — правильно з першої спроби.
      await _tap(tester, left: true, index: 1);
      await _tap(tester, left: false, index: 1);
      await tester.pump();

      expect(harness.result?.state, TaskAnswerState.correct);
      expect(harness.accuracy?.correct, 1);
      expect(harness.accuracy?.total, 2);
    });
  });
}
