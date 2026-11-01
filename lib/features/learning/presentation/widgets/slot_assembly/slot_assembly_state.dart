import 'dart:collection';

import 'package:school_tasks/features/learning/domain/evaluation/accuracy_result.dart';

/// Результат оцінки скидання елемента в слот.
enum DropOutcome {
  /// Скидання недійсне (слот зайнятий, елемент використаний тощо).
  ignored,

  /// Елемент не підходить до цього слота — спроба неправильна.
  incorrect,

  /// Елемент правильний для цього слота.
  correct,
}

/// Чистий стан складання зі слотів: без Flutter, без setState.
///
/// Відповідає лише за дані та правила: які слоти зайняті, які елементи
/// використані, куди елемент може потрапити, як рахується точність.
/// Побічні ефекти (звук, анімація, колбеки) лишаються у віджеті.
class SlotAssemblyState<TOption> {
  SlotAssemblyState({
    required List<TOption> options,
    required List<TOption> correctAnswers,
    required this.requiresSequentialSelection,
  }) : _options = options,
       _correctAnswers = correctAnswers,
       _slots = List<int?>.filled(correctAnswers.length, null);

  final List<TOption> _options;
  final List<TOption> _correctAnswers;
  final bool requiresSequentialSelection;

  final List<int?> _slots;
  final Set<int> _used = {};
  final Set<int> _attemptedSlots = {};
  final Set<int> _firstAttemptCorrectSlots = {};

  int _correctSlotsCount = 0;

  /// Індекс елемента в кожному слоті (null — слот порожній).
  List<int?> get slotOptionIndices => UnmodifiableListView(_slots);

  Set<int> get usedOptionIndices => UnmodifiableSetView(_used);

  int get correctSlotsCount => _correctSlotsCount;

  bool get isComplete => _slots.every((index) => index != null);

  bool isOptionUsed(int optionIndex) => _used.contains(optionIndex);

  /// Перший ще не використаний елемент.
  int? get nextUnusedOptionIndex {
    for (var i = 0; i < _options.length; i++) {
      if (!_used.contains(i)) return i;
    }

    return null;
  }

  int? get nextEmptySlot {
    for (var i = 0; i < _slots.length; i++) {
      if (_slots[i] == null) return i;
    }

    return null;
  }

  /// Слот, у який елемент може бути доставлений правильно, або null.
  int? findTargetSlot(int optionIndex) {
    final option = _options[optionIndex];
    final next = nextEmptySlot;

    if (next == null) return null;

    if (requiresSequentialSelection) {
      return _correctAnswers[next] == option ? next : null;
    }

    for (var i = 0; i < _correctAnswers.length; i++) {
      if (_slots[i] == null && _correctAnswers[i] == option) return i;
    }

    return null;
  }

  /// Чи можна фізично покласти елемент у слот (межі, зайнятість).
  bool canPlace(int optionIndex, int slotIndex) {
    return optionIndex >= 0 &&
        optionIndex < _options.length &&
        slotIndex >= 0 &&
        slotIndex < _slots.length &&
        !_used.contains(optionIndex) &&
        _slots[slotIndex] == null;
  }

  /// Оцінює скидання елемента в слот, нічого не змінюючи.
  DropOutcome classifyDrop(int optionIndex, int slotIndex) {
    if (!canPlace(optionIndex, slotIndex)) return DropOutcome.ignored;

    final next = nextEmptySlot;
    if (next == null) return DropOutcome.ignored;

    // У послідовному режимі можна заповнити лише наступний порожній слот.
    if (requiresSequentialSelection && slotIndex != next) {
      return DropOutcome.incorrect;
    }

    return _correctAnswers[slotIndex] == _options[optionIndex]
        ? DropOutcome.correct
        : DropOutcome.incorrect;
  }

  /// Реєструє неправильну спробу для слота.
  void recordIncorrectAttempt(int slotIndex) {
    _attemptedSlots.add(slotIndex);
  }

  /// Кладе правильний елемент у слот. Перед викликом перевірте [canPlace].
  void place(int optionIndex, int slotIndex) {
    assert(canPlace(optionIndex, slotIndex));

    _slots[slotIndex] = optionIndex;
    _used.add(optionIndex);
    _correctSlotsCount++;

    if (!_attemptedSlots.contains(slotIndex)) {
      _firstAttemptCorrectSlots.add(slotIndex);
    }
  }

  /// Точність: слоти, заповнені з першої спроби.
  AccuracyResult get accuracy => AccuracyResult(
    correct: _firstAttemptCorrectSlots.length,
    total: _correctAnswers.length,
  );

  /// Зібрана відповідь у порядку слотів. Лише для заповнених слотів.
  List<TOption> get answer => [for (final index in _slots) _options[index!]];
}
