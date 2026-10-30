sealed class SlotAssemblyInteractionMode {
  const SlotAssemblyInteractionMode();
}

class PressForSlotInteractionMode extends SlotAssemblyInteractionMode {
  const PressForSlotInteractionMode({
    this.fallingElementsEnabled = false,
    this.flightAnimationEnabled = false,
    this.fallingDuration = const Duration(seconds: 10),
    this.flightDuration = const Duration(milliseconds: 700),
  });

  final bool fallingElementsEnabled;
  final bool flightAnimationEnabled;

  /// Тривалість падіння елементів.
  final Duration fallingDuration;

  /// Тривалість переміщення вибраного елемента до слота.
  final Duration flightDuration;
}

class DragToSlotInteractionMode extends SlotAssemblyInteractionMode {
  const DragToSlotInteractionMode({this.dragScale = 1.0});

  /// Масштаб бульбашки під час перетягування.
  final double dragScale;
}
