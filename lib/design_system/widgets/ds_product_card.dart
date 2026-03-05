import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalog_app/core/theme/app_theme.dart';
import 'package:catalog_app/design_system/widgets/ds_price_display.dart';
import 'package:catalog_app/design_system/widgets/ds_rating_badge.dart';
import 'package:catalog_app/design_system/widgets/ds_stock_indicator.dart';
import 'package:catalog_app/features/catalog/domain/entities/product.dart';
import 'package:flutter/material.dart';

class DsProductCard extends StatelessWidget {
  const DsProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.selected = false,
  });

  final Product product;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      color: selected
          ? scheme.surfaceContainerHighest.withAlpha(166)
          : scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: scheme.outline.withAlpha(89)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'product-image-${product.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: _ProductImage(url: product.thumbnail),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      product.brand,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    DsPriceDisplay(
                      price: product.price,
                      discountedPrice: product.discountedPrice,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        DsRatingBadge(rating: product.rating),
                        const SizedBox(width: AppSpacing.sm),
                        Flexible(child: DsStockIndicator(stock: product.stock)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return _placeholder(context);
    }

    return CachedNetworkImage(
      imageUrl: url,
      width: 88,
      height: 88,
      fit: BoxFit.cover,
      placeholder: (_, _) => _placeholder(context),
      errorWidget: (_, _, _) => _placeholder(context),
    );
  }

  Widget _placeholder(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 88,
      height: 88,
      color: scheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: scheme.onSurfaceVariant,
      ),
    );
  }
}
