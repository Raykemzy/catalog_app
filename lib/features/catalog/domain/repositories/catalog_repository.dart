import 'package:catalog_app/features/catalog/domain/entities/paged_result.dart';
import 'package:catalog_app/features/catalog/domain/entities/product.dart';

abstract class CatalogRepository {
  Future<PagedResult<Product>> fetchProducts({
    required int skip,
    required int limit,
    String query,
    String? category,
  });

  Future<List<String>> fetchCategories();

  Future<Product> fetchProductById(int id);
}
