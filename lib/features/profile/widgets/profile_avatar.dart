import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.avatar});

  final String avatar;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 36,
      child: Text(avatar, style: const TextStyle(fontSize: 36)),
    );
  }
}
