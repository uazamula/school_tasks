import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_preferences.dart';
// dart run build_runner build - у терміналі
part 'preferences_provider.g.dart';

@Riverpod(keepAlive: true)
Future<AppPreferences> appPreferences(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();

  return AppPreferences(prefs);
}
