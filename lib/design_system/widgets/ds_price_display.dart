import 'package:catalog_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DsPriceDisplay extends StatelessWidget {
  const DsPriceDisplay({
    super.key,
    required this.price,
    required this.discountedPrice,
  });

  final double? price;
  final double? discountedPrice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (price == null) {
      return Text(
        'Price unavailable',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colors.onSurfaceVariant,
        ),
      );
    }

    final hasDiscount = discountedPrice != null && discountedPrice! < price!;
    return Wrap(
      spacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '\$${(hasDiscount ? discountedPrice : price)!.toStringAsFixed(2)}',
          style: theme.textTheme.bodyLarge?.copyWith(color: colors.primary),
        ),
        if (hasDiscount)
          Text(
            '\$${price!.toStringAsFixed(2)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }
}
