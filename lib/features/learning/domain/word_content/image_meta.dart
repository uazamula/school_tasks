/// Розмір зображення в пікселях.
class ImageMeta {
  const ImageMeta(this.width, this.height) : assert(width > 0 && height > 0);

  final int width;
  final int height;

  /// Співвідношення сторін: ширина / висота.
  double get aspect => width / height;

  /// Менша зі сторін (показник роздільної здатності).
  int get shortSide => width < height ? width : height;

  @override
  String toString() => '${width}x$height';
}

/// Таблиця розмірів зображень: шлях ресурсу → [ImageMeta].
///
/// Ключі збігаються з `WordConcept.image`
/// (наприклад, `assets/images/ants.png`).
/// Дані генерує `dart run tool/project_tools.dart images`.
class ImageMetaTable {
  const ImageMetaTable(this._entries);

  final Map<String, ImageMeta> _entries;

  /// Розмір зображення за шляхом; null, якщо шляху немає або запису немає.
  ImageMeta? of(String? imagePath) {
    if (imagePath == null) return null;
    return _entries[imagePath.trim()];
  }

  Iterable<String> get paths => _entries.keys;

  int get length => _entries.length;
}
