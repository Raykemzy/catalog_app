import 'package:catalog_app/core/theme/app_theme.dart';
import 'package:catalog_app/core/theme/theme_toggle_button.dart';
import 'package:catalog_app/design_system/widgets/ds_category_chip.dart';
import 'package:catalog_app/design_system/widgets/ds_empty_state.dart';
import 'package:catalog_app/design_system/widgets/ds_error_state.dart';
import 'package:catalog_app/design_system/widgets/ds_loading_skeleton.dart';
import 'package:catalog_app/design_system/widgets/ds_product_card.dart';
import 'package:catalog_app/design_system/widgets/ds_search_bar.dart';
import 'package:catalog_app/features/catalog/presentation/cubit/product_list_cubit.dart';
import 'package:catalog_app/features/catalog/presentation/cubit/product_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductListPanel extends StatefulWidget {
  const ProductListPanel({
    super.key,
    required this.onProductSelected,
    required this.selectedProductId,
    this.showUtilityActions = false,
  });

  final ValueChanged<int> onProductSelected;
  final int? selectedProductId;
  final bool showUtilityActions;

  @override
  State<ProductListPanel> createState() => _ProductListPanelState();
}

class _ProductListPanelState extends State<ProductListPanel> {
  late final ScrollController _scrollController;
  bool _playedStagger = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.extentAfter < 380) {
          context.read<ProductListCubit>().loadNextPage();
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListCubit, ProductListState>(
      builder: (context, state) {
        final shouldAnimateStagger =
            !_playedStagger &&
            state.status == ProductListStatus.success &&
            state.products.isNotEmpty;
        if (shouldAnimateStagger) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _playedStagger = true);
            }
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showUtilityActions)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.sm,
                  0,
                ),
                child: Row(
                  children: [
                    Text(
                      'Catalog',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Showcase',
                      onPressed: () => context.push('/showcase'),
                      icon: const Icon(Icons.widgets_outlined),
                    ),
                    const ThemeToggleButton(),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: DsSearchBar(
                value: state.query,
                onChanged: context.read<ProductListCubit>().updateQuery,
              ),
            ),
            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return DsCategoryChip(
                      label: 'All',
                      selected: state.selectedCategory == null,
                      onTap: () =>
                          context.read<ProductListCubit>().updateCategory(null),
                    );
                  }

                  final category = state.categories[index - 1];
                  return DsCategoryChip(
                    label: category,
                    selected: state.selectedCategory == category,
                    onTap: () => context
                        .read<ProductListCubit>()
                        .updateCategory(category),
                  );
                },
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.sm),
                itemCount: state.categories.length + 1,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (state.status == ProductListStatus.success ||
                state.status == ProductListStatus.empty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: _DataSourceBadge(
                  isFromCache: state.isFromCache,
                  cacheTimestampEpochMs: state.cacheTimestampEpochMs,
                ),
              ),
            Expanded(child: _buildBody(context, state)),
          ],
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProductListState state) {
    if (state.status == ProductListStatus.loading && !state.isRefreshing) {
      return ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemBuilder: (_, _) => const _ProductCardSkeleton(),
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemCount: 8,
      );
    }

    if (state.status == ProductListStatus.error) {
      return DsErrorState(
        message: state.errorMessage ?? 'Could not load products.',
        onRetry: context.read<ProductListCubit>().retry,
      );
    }

    if (state.status == ProductListStatus.empty) {
      return const DsEmptyState(
        title: 'No products found',
        subtitle: 'Try changing your search term or category.',
      );
    }

    return RefreshIndicator(
      onRefresh: context.read<ProductListCubit>().refresh,
      child: ListView.separated(
        key: const PageStorageKey('product-list-scroll'),
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        itemBuilder: (context, index) {
          final hasRefreshBanner = state.isRefreshing;
          final productStartIndex = hasRefreshBanner ? 1 : 0;

          if (hasRefreshBanner && index == 0) {
            return const _RefreshingBanner();
          }

          final productIndex = index - productStartIndex;

          if (productIndex == state.products.length) {
            if (!state.isLoadingMore) return const SizedBox.shrink();
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2.4)),
            );
          }

          final product = state.products[productIndex];
          final card = DsProductCard(
            product: product,
            selected: widget.selectedProductId == product.id,
            onTap: () => widget.onProductSelected(product.id),
          );
          if (!_playedStagger) {
            return TweenAnimationBuilder<double>(
              duration: Duration(
                milliseconds: 260 + (index * 45).clamp(0, 500),
              ),
              curve: Curves.easeOutCubic,
              tween: Tween(begin: 0, end: 1),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * 10),
                    child: child,
                  ),
                );
              },
              child: card,
            );
          }
          return card;
        },
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemCount: state.products.length + 1 + (state.isRefreshing ? 1 : 0),
      ),
    );
  }
}

class _RefreshingBanner extends StatefulWidget {
  const _RefreshingBanner();

  @override
  State<_RefreshingBanner> createState() => _RefreshingBannerState();
}

class _RefreshingBannerState extends State<_RefreshingBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RotationTransition(
            turns: _controller,
            child: Icon(Icons.refresh_rounded, size: 18, color: color),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Refreshing products',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _DataSourceBadge extends StatelessWidget {
  const _DataSourceBadge({
    required this.isFromCache,
    required this.cacheTimestampEpochMs,
  });

  final bool isFromCache;
  final int? cacheTimestampEpochMs;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = isFromCache
        ? scheme.secondaryContainer.withAlpha(150)
        : scheme.surfaceContainerHighest;
    final fg = isFromCache
        ? scheme.onSecondaryContainer
        : scheme.onSurfaceVariant;

    String text = isFromCache ? 'Offline cache' : 'Live data';
    if (isFromCache && cacheTimestampEpochMs != null) {
      final cachedAt = DateTime.fromMillisecondsSinceEpoch(
        cacheTimestampEpochMs!,
      );
      text =
          '$text • ${cachedAt.hour.toString().padLeft(2, '0')}:${cachedAt.minute.toString().padLeft(2, '0')}';
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: fg),
        ),
      ),
    );
  }
}

class _ProductCardSkeleton extends StatelessWidget {
  const _ProductCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(89),
        ),
      ),
      child: Row(
        children: const [
          DsLoadingSkeleton(height: 88, width: 88),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DsLoadingSkeleton(height: 16, width: 190),
                SizedBox(height: AppSpacing.sm),
                DsLoadingSkeleton(height: 14, width: 120),
                SizedBox(height: AppSpacing.md),
                DsLoadingSkeleton(height: 14, width: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
