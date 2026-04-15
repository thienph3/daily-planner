import 'package:flutter/material.dart';

/// Màn hình placeholder cho feature Mood.
class MoodPlaceholderScreen extends StatelessWidget {
  const MoodPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Mood',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
