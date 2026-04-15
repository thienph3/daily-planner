import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';

/// Widget shimmer loading placeholder, tương thích cả light và dark theme.
class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.darkSurface : Colors.grey.shade300;
    final highlightColor = isDark
        ? AppColors.darkSurface.withValues(alpha: 0.6)
        : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Danh sách shimmer items cho feature screens khi đang loading.
class ShimmerListWidget extends StatelessWidget {
  final int itemCount;

  const ShimmerListWidget({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.paddingStandard),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.gapItem),
      itemBuilder: (context, index) => ShimmerWidget(
        width: double.infinity,
        height: 72,
        borderRadius: AppSpacing.borderRadiusCard,
      ),
    );
  }
}
