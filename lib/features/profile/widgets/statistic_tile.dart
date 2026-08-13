import 'package:flutter/material.dart';

class StatisticTile extends StatelessWidget {
  const StatisticTile({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Text(value, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
