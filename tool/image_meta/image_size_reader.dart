import 'dart:typed_data';

/// Розмір зображення в пікселях.
class ImageSize {
  const ImageSize(this.width, this.height);

  final int width;
  final int height;
}

/// Читає розмір PNG або JPEG із заголовка файлу без декодування картинки.
/// Повертає null, якщо формат не підтримується або файл пошкоджений.
ImageSize? readImageSize(Uint8List bytes) {
  return _readPng(bytes) ?? _readJpeg(bytes);
}

/// PNG: 8 байтів сигнатури, далі чанк IHDR зі зміщенням 16 і 20
/// (ширина та висота, 4 байти, big-endian).
ImageSize? _readPng(Uint8List b) {
  const signature = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];

  if (b.length < 24) return null;

  for (var i = 0; i < signature.length; i++) {
    if (b[i] != signature[i]) return null;
  }

  // Тип чанка має бути 'IHDR'.
  if (b[12] != 0x49 || b[13] != 0x48 || b[14] != 0x44 || b[15] != 0x52) {
    return null;
  }

  final width = _uint32(b, 16);
  final height = _uint32(b, 20);

  if (width <= 0 || height <= 0) return null;

  return ImageSize(width, height);
}

/// JPEG: проходимо сегменти, поки не знайдемо маркер SOF (початок кадру),
/// де зберігаються висота та ширина.
ImageSize? _readJpeg(Uint8List b) {
  if (b.length < 4 || b[0] != 0xFF || b[1] != 0xD8) return null;

  var i = 2;

  while (i + 3 < b.length) {
    if (b[i] != 0xFF) {
      i++;
      continue;
    }

    final marker = b[i + 1];

    // Байти-заповнювачі 0xFF.
    if (marker == 0xFF) {
      i++;
      continue;
    }

    // Маркери без довжини.
    if (marker == 0x00 ||
        marker == 0x01 ||
        (marker >= 0xD0 && marker <= 0xD8)) {
      i += 2;
      continue;
    }

    // Кінець зображення або початок даних без SOF — розміру немає.
    if (marker == 0xD9 || marker == 0xDA) return null;

    final length = (b[i + 2] << 8) | b[i + 3];

    final isStartOfFrame =
        marker >= 0xC0 &&
        marker <= 0xCF &&
        marker != 0xC4 && // DHT
        marker != 0xC8 && // JPG
        marker != 0xCC; // DAC

    if (isStartOfFrame) {
      if (i + 8 >= b.length) return null;

      final height = (b[i + 5] << 8) | b[i + 6];
      final width = (b[i + 7] << 8) | b[i + 8];

      if (width <= 0 || height <= 0) return null;

      return ImageSize(width, height);
    }

    i += 2 + length;
  }

  return null;
}

int _uint32(Uint8List b, int offset) {
  return (b[offset] << 24) |
      (b[offset + 1] << 16) |
      (b[offset + 2] << 8) |
      b[offset + 3];
}
