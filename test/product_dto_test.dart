import 'package:catalog_app/features/catalog/data/models/product_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps missing and invalid fields safely', () {
    final product = ProductDto.fromJson({
      'id': 12,
      'title': null,
      'description': null,
      'price': -99,
      'brand': null,
      'category': null,
      'thumbnail': 'not-a-url',
      'images': ['https://example.com/img.png', 'broken'],
      'rating': 9,
      'stock': -3,
    });

    expect(product.id, 12);
    expect(product.title, 'Untitled product');
    expect(product.description, 'No description available.');
    expect(product.price, isNull);
    expect(product.brand, 'Unknown brand');
    expect(product.category, 'Uncategorized');
    expect(product.thumbnail, '');
    expect(product.images, ['https://example.com/img.png']);
    expect(product.rating, 5);
    expect(product.stock, 0);
  });

  test('maps valid payload and computes discounted price', () {
    final product = ProductDto.fromJson({
      'id': 99,
      'title': 'Headphones',
      'description': 'Noise cancelling',
      'price': 250,
      'discountPercentage': 20,
      'rating': 4.2,
      'stock': 8,
      'brand': 'Acme',
      'category': 'audio',
      'thumbnail': 'https://example.com/t.png',
      'images': ['https://example.com/i1.png'],
    });

    expect(product.id, 99);
    expect(product.title, 'Headphones');
    expect(product.price, 250);
    expect(product.discountedPrice, 200);
    expect(product.thumbnail, 'https://example.com/t.png');
    expect(product.images.first, 'https://example.com/t.png');
  });
}
