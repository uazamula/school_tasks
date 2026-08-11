import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:school_tasks/core/preferences/preferences_provider.dart';
import 'package:school_tasks/features/profile/model/user_profile.dart';

part 'profile_controller.g.dart';

@Riverpod(keepAlive: true)
class ProfileController extends _$ProfileController {
  @override
  Future<UserProfile> build() async {
    final preferences = await ref.watch(appPreferencesProvider.future);

    return preferences.getUserProfile();
  }

  Future<void> saveProfile(UserProfile profile) async {
    final preferences = await ref.read(appPreferencesProvider.future);

    await preferences.setUserProfile(profile);

    state = AsyncData(profile);
  }

  Future<void> setName(String name) async {
    final profile = state.value;

    if (profile == null) return;

    await saveProfile(profile.copyWith(name: name.trim()));
  }

  Future<void> setAvatar(String avatar) async {
    final profile = state.value;

    if (profile == null) return;

    await saveProfile(profile.copyWith(avatar: avatar));
  }
}
