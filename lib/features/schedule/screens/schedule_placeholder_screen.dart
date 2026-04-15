import 'package:flutter/material.dart';

/// Màn hình placeholder cho feature Lịch trình.
class SchedulePlaceholderScreen extends StatelessWidget {
  const SchedulePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Lịch trình',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
