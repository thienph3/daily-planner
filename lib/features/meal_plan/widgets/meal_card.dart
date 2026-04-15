import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';

/// Widget hiển thị thông tin một bữa ăn với icon kawaii.
class MealCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String content;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const MealCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.content,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasContent = content.isNotEmpty;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingStandard),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: AppSpacing.gapItem),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasContent ? content : 'Nhấn để thêm...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: hasContent
                            ? null
                            : AppColors.textSecondary,
                        fontStyle:
                            hasContent ? null : FontStyle.italic,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.close_rounded, size: 20),
                  color: AppColors.error,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
