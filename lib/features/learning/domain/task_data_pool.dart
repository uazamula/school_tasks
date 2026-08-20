import 'dart:math';

class TaskDataPool<T> {
  TaskDataPool({required List<T> items, Random? random})
    : _items = List.of(items),
      _random = random ?? Random();

  final List<T> _items;
  final Random _random;

  bool get isEmpty => _items.isEmpty;

  int get length => _items.length;

  T takeRandom() {
    final index = _random.nextInt(_items.length);

    return _items.removeAt(index);
  }
}
