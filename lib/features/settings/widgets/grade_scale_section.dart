import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:school_tasks/features/learning/domain/evaluation/grade_scale.dart';
import 'package:school_tasks/features/learning/providers/grade_scale_controller.dart';

class GradeScaleSection extends ConsumerWidget {
  const GradeScaleSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradeScaleAsync = ref.watch(gradeScaleControllerProvider);

    return gradeScaleAsync.when(
      loading: () => const ListTile(
        title: Text('Шкала оцінювання'),
        trailing: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => ListTile(
        title: const Text('Шкала оцінювання'),
        subtitle: Text('Помилка: $error'),
      ),
      data: (scale) {
        return ListTile(
          title: const Text('Шкала оцінювання'),
          trailing: DropdownButton<GradeScale>(
            value: scale,
            onChanged: (value) {
              if (value == null) return;

              ref
                  .read(gradeScaleControllerProvider.notifier)
                  .setGradeScale(value);
            },
            items: const [
              DropdownMenuItem(
                value: GradeScale.hundred,
                child: Text('100-бальна'),
              ),
              DropdownMenuItem(
                value: GradeScale.twelve,
                child: Text('12-бальна'),
              ),
              DropdownMenuItem(
                value: GradeScale.visual,
                child: Text('Візуальна'),
              ),
            ],
          ),
        );
      },
    );
  }
}
