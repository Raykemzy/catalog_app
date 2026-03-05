import 'package:catalog_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DsRatingBadge extends StatelessWidget {
  const DsRatingBadge({super.key, required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 14, color: scheme.primary),
          const SizedBox(width: 4),
          Text(rating.toStringAsFixed(1), style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
