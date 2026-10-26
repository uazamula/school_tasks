sealed class SlotAssemblyInteractionMode {
  const SlotAssemblyInteractionMode();
}

class PressForSlotInteractionMode extends SlotAssemblyInteractionMode {
  const PressForSlotInteractionMode({
    this.fallingElementsEnabled = false,
    this.flightAnimationEnabled = false,
  });

  final bool fallingElementsEnabled;
  final bool flightAnimationEnabled;
}

class DragToSlotInteractionMode extends SlotAssemblyInteractionMode {
  const DragToSlotInteractionMode();
}
