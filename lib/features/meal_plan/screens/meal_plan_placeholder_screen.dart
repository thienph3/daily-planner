import 'package:flutter/material.dart';

/// Màn hình placeholder cho feature Bữa ăn.
class MealPlanPlaceholderScreen extends StatelessWidget {
  const MealPlanPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Bữa ăn',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
