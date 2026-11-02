/// Фіксовані ретро-палітри у форматі 0xRRGGBB.
abstract final class RetroPalettes {
  static const List<int> mono = [0x000000, 0xFFFFFF];

  /// CGA, палітра 1 (яскрава).
  static const List<int> cga = [0x000000, 0x55FFFF, 0xFF55FF, 0xFFFFFF];

  /// 16 кольорів CGA/EGA.
  static const List<int> ega16 = [
    0x000000, 0x0000AA, 0x00AA00, 0x00AAAA,
    0xAA0000, 0xAA00AA, 0xAA5500, 0xAAAAAA,
    0x555555, 0x5555FF, 0x55FF55, 0x55FFFF,
    0xFF5555, 0xFF55FF, 0xFFFF55, 0xFFFFFF,
  ];

  /// VGA-подібна палітра: 16 EGA + куб 6×6×6 + 24 сірих = 256.
  static final List<int> vga256 = _buildVga();

  static List<int>? forBits(int bits) => switch (bits) {
    1 => mono,
    2 => cga,
    4 => ega16,
    8 => vga256,
    _ => null,
  };

  static List<int> _buildVga() {
    const steps = [0, 51, 102, 153, 204, 255];
    final colors = <int>[...ega16];

    for (final r in steps) {
      for (final g in steps) {
        for (final b in steps) {
          colors.add((r << 16) | (g << 8) | b);
        }
      }
    }

    for (var i = 1; i <= 24; i++) {
      final v = (i * 255 / 25).round();
      colors.add((v << 16) | (v << 8) | v);
    }

    return colors;
  }
}