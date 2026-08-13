import 'package:flutter/material.dart';

class TopicStatusIndicator extends StatelessWidget {
  const TopicStatusIndicator({super.key, this.status});

  final Object? status;

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.circle_outlined, size: 20);
  }
}
