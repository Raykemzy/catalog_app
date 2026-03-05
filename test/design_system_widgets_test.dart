import 'package:catalog_app/core/theme/app_theme.dart';
import 'package:catalog_app/design_system/widgets/ds_category_chip.dart';
import 'package:catalog_app/design_system/widgets/ds_price_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  testWidgets('category chip keeps 48dp hit target with 32dp visual body', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(DsCategoryChip(label: 'Phones', selected: true, onTap: () {})),
    );

    final rootSize = tester.getSize(find.byType(SizedBox).first);
    expect(rootSize.height, 48);
  });

  testWidgets('price display shows unavailable state', (tester) async {
    await tester.pumpWidget(
      _wrap(const DsPriceDisplay(price: null, discountedPrice: null)),
    );

    expect(find.text('Price unavailable'), findsOneWidget);
  });
}
