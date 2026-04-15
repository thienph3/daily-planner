import 'package:flutter/material.dart';

/// Màn hình placeholder cho feature To-Do.
class TodoPlaceholderScreen extends StatelessWidget {
  const TodoPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'To-Do',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
