import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';

/// Спосіб вибору частин: дотик, перетягування або обидва.
enum FractionSelectionMode { tap, drag, both }

/// Прикраса торта.
enum FractionDecoration { plain, sprinkles }

class FractionTaskData extends TaskData {
  const FractionTaskData({
    required super.prompt,
    required this.numerator,
    required this.denominator,
    required this.parts,
    this.selectionMode = FractionSelectionMode.both,
    this.decoration = FractionDecoration.plain,
    this.baseColor,
    this.selectedColor,
  });

  final FractionSelectionMode selectionMode;
  final int numerator;
  final int denominator;
  final int parts;
  final FractionDecoration decoration;

  /// Колір невиділеної частини. null — колір за замовчуванням.
  final Color? baseColor;

  /// Колір таці, що видно на місці забраного шматка. null — колір теми.
  final Color? selectedColor;
}
