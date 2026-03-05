import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalog_app/core/theme/app_theme.dart';
import 'package:catalog_app/core/theme/theme_toggle_button.dart';
import 'package:catalog_app/design_system/widgets/ds_empty_state.dart';
import 'package:catalog_app/design_system/widgets/ds_error_state.dart';
import 'package:catalog_app/design_system/widgets/ds_price_display.dart';
import 'package:catalog_app/design_system/widgets/ds_rating_badge.dart';
import 'package:catalog_app/design_system/widgets/ds_stock_indicator.dart';
import 'package:catalog_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:catalog_app/features/catalog/presentation/cubit/product_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key,
    required this.productId,
    this.showAppBar = true,
  });

  final int productId;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductDetailCubit(repository: context.read<CatalogRepository>())
            ..load(productId),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: showAppBar
                ? AppBar(
                    centerTitle: false,
                    title: const Text('Product details'),
                    leading: IconButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/');
                        }
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    actions: [
                      IconButton(
                        tooltip: 'Showcase',
                        onPressed: () => context.push('/showcase'),
                        icon: const Icon(Icons.widgets_outlined),
                      ),
                      const ThemeToggleButton(),
                    ],
                  )
                : null,
            body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
              builder: (context, state) {
                switch (state.status) {
                  case ProductDetailStatus.loading:
                  case ProductDetailStatus.initial:
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    );
                  case ProductDetailStatus.error:
                    return DsErrorState(
                      message:
                          state.message ?? 'Could not load product details.',
                      onRetry: () =>
                          context.read<ProductDetailCubit>().load(productId),
                    );
                  case ProductDetailStatus.loaded:
                    final product = state.product;
                    if (product == null) {
                      return const DsEmptyState(
                        title: 'Product not found',
                        subtitle: 'This product may have been removed.',
                      );
                    }

                    final images = product.images.isNotEmpty
                        ? product.images
                        : [if (product.thumbnail.isNotEmpty) product.thumbnail];

                    return TweenAnimationBuilder<double>(
                      key: ValueKey('detail-content-${product.id}'),
                      tween: Tween(begin: 0, end: 1),
                      curve: Curves.easeOutCubic,
                      duration: const Duration(milliseconds: 260),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - value) * 12),
                            child: child,
                          ),
                        );
                      },
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 220,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final image = images[index];
                                        final imageWidget = ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            AppRadius.md,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: image,
                                            width: 300,
                                            fit: BoxFit.cover,
                                            errorWidget: (_, _, _) =>
                                                _fallbackImage(context),
                                          ),
                                        );

                                        if (index == 0) {
                                          return Hero(
                                            tag: 'product-image-${product.id}',
                                            child: imageWidget,
                                          );
                                        }
                                        return imageWidget;
                                      },
                                      separatorBuilder: (_, _) =>
                                          const SizedBox(width: AppSpacing.sm),
                                      itemCount: images.isEmpty
                                          ? 1
                                          : images.length,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  Text(
                                    product.title,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.displayLarge,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    '${product.brand} • ${product.category}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  DsPriceDisplay(
                                    price: product.price,
                                    discountedPrice: product.discountedPrice,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Row(
                                    children: [
                                      DsRatingBadge(rating: product.rating),
                                      const SizedBox(width: AppSpacing.md),
                                      DsStockIndicator(stock: product.stock),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  Text(
                                    'Description',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    product.description,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _fallbackImage(BuildContext context) {
    return Container(
      width: 300,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
