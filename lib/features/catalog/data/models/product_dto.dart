import 'package:catalog_app/core/logging/app_logger.dart';
import 'package:catalog_app/features/catalog/domain/entities/product.dart';

class ProductDto {
  const ProductDto._();

  static Product fromJson(Map<String, dynamic> json) {
    final id = _toInt(json['id']) ?? 0;
    final title = _toString(json['title'])?.trim();
    final description = _toString(json['description'])?.trim();
    final brand = _toString(json['brand'])?.trim();
    final category = _toString(json['category'])?.trim();

    final rawPrice = _toDouble(json['price']);
    double? price;
    if (rawPrice == null || rawPrice < 0) {
      AppLogger.error('Product($id) has missing/negative price.');
      price = null;
    } else {
      price = rawPrice;
    }

    final discount = (_toDouble(json['discountPercentage']) ?? 0).clamp(0, 99);
    final rating = (_toDouble(json['rating']) ?? 0).clamp(0, 5);
    final stock = (_toInt(json['stock']) ?? 0).clamp(0, 100000);

    final thumbnail = _validatedImage(_toString(json['thumbnail']));

    final images = <String>[];
    final rawImages = json['images'];
    if (rawImages is List) {
      for (final item in rawImages) {
        final url = _validatedImage(_toString(item));
        if (url.isNotEmpty) {
          images.add(url);
        }
      }
    }

    if (thumbnail.isNotEmpty && !images.contains(thumbnail)) {
      images.insert(0, thumbnail);
    }

    if (thumbnail.isEmpty && images.isEmpty) {
      AppLogger.warn('Product($id) has missing/invalid image url.');
    }

    return Product(
      id: id,
      title: title?.isNotEmpty == true ? title! : 'Untitled product',
      description: description?.isNotEmpty == true
          ? description!
          : 'No description available.',
      price: price,
      discountPercentage: discount.toDouble(),
      rating: rating.toDouble(),
      stock: stock,
      brand: brand?.isNotEmpty == true ? brand! : 'Unknown brand',
      category: category?.isNotEmpty == true ? category! : 'Uncategorized',
      thumbnail: thumbnail,
      images: images,
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }

  static double? _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse('$value');
  }

  static String? _toString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static String _validatedImage(String? value) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) return '';
    final uri = Uri.tryParse(raw);
    final valid =
        uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https');
    return valid ? raw : '';
  }
}
