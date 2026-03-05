import 'package:catalog_app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app builds', (tester) async {
    await tester.pumpWidget(const CatalogApp());
    expect(find.byType(CatalogApp), findsOneWidget);
  });
}
