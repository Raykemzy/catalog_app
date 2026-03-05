import 'package:catalog_app/core/theme/app_theme.dart';
import 'package:catalog_app/core/theme/theme_mode_cubit.dart';
import 'package:catalog_app/design_system/widgets/ds_category_chip.dart';
import 'package:catalog_app/design_system/widgets/ds_empty_state.dart';
import 'package:catalog_app/design_system/widgets/ds_error_state.dart';
import 'package:catalog_app/design_system/widgets/ds_loading_skeleton.dart';
import 'package:catalog_app/design_system/widgets/ds_price_display.dart';
import 'package:catalog_app/design_system/widgets/ds_product_card.dart';
import 'package:catalog_app/design_system/widgets/ds_rating_badge.dart';
import 'package:catalog_app/design_system/widgets/ds_search_bar.dart';
import 'package:catalog_app/design_system/widgets/ds_stock_indicator.dart';
import 'package:catalog_app/features/catalog/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  String _search = '';

  static const _sampleProduct = Product(
    id: 1001,
    title: 'Minimal Wireless Headphones',
    description: 'Reference product used for design system showcase states.',
    price: 179,
    discountPercentage: 15,
    rating: 4.4,
    stock: 9,
    brand: 'Studio Audio',
    category: 'audio',
    thumbnail: '',
    images: [],
  );

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeModeCubit>().state;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Design System Showcase'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text('Theme', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.light, label: Text('Light')),
              ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
              ButtonSegment(value: ThemeMode.system, label: Text('System')),
            ],
            selected: {themeMode},
            onSelectionChanged: (modes) {
              context.read<ThemeModeCubit>().setMode(modes.first);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Inputs & Chips',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          DsSearchBar(
            value: _search,
            onChanged: (value) => setState(() => _search = value),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              DsCategoryChip(label: 'All', selected: true, onTap: () {}),
              DsCategoryChip(label: 'Audio', selected: false, onTap: () {}),
              DsCategoryChip(
                label: 'Disabled',
                selected: false,
                enabled: false,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Cards & Badges',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          DsProductCard(product: _sampleProduct, onTap: () {}),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: const [
              DsRatingBadge(rating: 4.4),
              SizedBox(width: AppSpacing.sm),
              DsStockIndicator(stock: 9),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const DsPriceDisplay(price: 179, discountedPrice: 152.15),
          const SizedBox(height: AppSpacing.lg),
          Text('States', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          const DsLoadingSkeleton(height: 48),
          const SizedBox(height: AppSpacing.md),
          const SizedBox(
            height: 180,
            child: DsEmptyState(
              title: 'Empty State',
              subtitle: 'This is how empty placeholders appear.',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 210,
            child: DsErrorState(
              message: 'Sample error message',
              onRetry: () {},
            ),
          ),
        ],
      ),
    );
  }
}
