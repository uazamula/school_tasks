class UserProfile {
  const UserProfile({required this.name, required this.avatar});

  final String name;
  final String avatar;

  UserProfile copyWith({String? name, String? avatar}) {
    return UserProfile(name: name ?? this.name, avatar: avatar ?? this.avatar);
  }
}
