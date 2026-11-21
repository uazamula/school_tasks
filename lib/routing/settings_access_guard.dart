import 'dart:async';

import 'package:flutter/foundation.dart';

/// Стан доступу до налаштувань для роутера (він поза Riverpod).
class SettingsAccessGuard extends ChangeNotifier {
  bool _kidsUi = false;
  bool _loaded = false;

  /// true, якщо батьківський контроль щойно пройдено.
  bool unlocked = false;

  bool get kidsUi => _kidsUi;

  /// Оновлює режим. Роутер перевіряє поточний маршрут лише після першого
  /// завантаження режиму (холодний старт на /settings). Пізніші перемикання
  /// не виштовхують користувача з налаштувань.
  void updateKidsUi(bool value) {
    final first = !_loaded;

    _loaded = true;
    _kidsUi = value;

    if (first) {
      scheduleMicrotask(notifyListeners);
    }
  }
}

final settingsAccessGuard = SettingsAccessGuard();
