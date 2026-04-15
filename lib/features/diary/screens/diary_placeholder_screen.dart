import 'package:flutter/material.dart';

/// Màn hình placeholder cho feature Nhật ký.
class DiaryPlaceholderScreen extends StatelessWidget {
  const DiaryPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Nhật ký',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
