import 'package:catalog_app/core/constants/app_constants.dart';
import 'package:catalog_app/core/theme/app_theme.dart';
import 'package:catalog_app/core/theme/theme_toggle_button.dart';
import 'package:catalog_app/design_system/widgets/ds_empty_state.dart';
import 'package:catalog_app/features/catalog/presentation/screens/product_detail_screen.dart';
import 'package:catalog_app/features/catalog/presentation/screens/product_list_panel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CatalogRouteScreen extends StatefulWidget {
  const CatalogRouteScreen({super.key, this.selectedProductId});

  final int? selectedProductId;

  @override
  State<CatalogRouteScreen> createState() => _CatalogRouteScreenState();
}

class _CatalogRouteScreenState extends State<CatalogRouteScreen> {
  int? _selectedProductId;

  @override
  void initState() {
    super.initState();
    _selectedProductId = widget.selectedProductId;
  }

  @override
  void didUpdateWidget(covariant CatalogRouteScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedProductId != widget.selectedProductId) {
      _selectedProductId = widget.selectedProductId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide =
        MediaQuery.sizeOf(context).width >= AppConstants.tabletBreakpoint;

    if (!isWide && widget.selectedProductId != null) {
      return ProductDetailScreen(productId: widget.selectedProductId!);
    }

    if (!isWide) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text('Catalog'),
          actions: [
            IconButton(
              tooltip: 'Showcase',
              onPressed: () => context.push('/showcase'),
              icon: const Icon(Icons.widgets_outlined),
            ),
            const ThemeToggleButton(),
          ],
        ),
        body: ProductListPanel(
          selectedProductId: null,
          onProductSelected: (id) => context.push('/products/$id'),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: 380,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Theme.of(
                        context,
                      ).extension<AppSemanticColors>()!.divider,
                    ),
                  ),
                ),
                child: ProductListPanel(
                  selectedProductId: _selectedProductId,
                  onProductSelected: _onWideProductSelected,
                  showUtilityActions: true,
                ),
              ),
            ),
            Expanded(
              child: _selectedProductId == null
                  ? const DsEmptyState(
                      title: 'Pick a product',
                      subtitle:
                          'Select an item from the list to view details here.',
                      icon: Icons.inventory_2_outlined,
                    )
                  : ProductDetailScreen(
                      key: ValueKey(_selectedProductId),
                      productId: _selectedProductId!,
                      showAppBar: false,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _onWideProductSelected(int id) {
    if (_selectedProductId != id) {
      setState(() => _selectedProductId = id);
    }
  }
}
