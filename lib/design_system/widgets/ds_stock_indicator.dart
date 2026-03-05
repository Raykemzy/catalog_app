import 'package:catalog_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DsStockIndicator extends StatelessWidget {
  const DsStockIndicator({super.key, required this.stock});

  final int stock;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>()!;

    Color color;
    String label;

    if (stock <= 0) {
      color = semantic.danger;
      label = 'Out of stock';
    } else if (stock < 10) {
      color = semantic.warning;
      label = 'Low stock';
    } else {
      color = semantic.success;
      label = 'In stock';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '$label ($stock)',
          style: theme.textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
