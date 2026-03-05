import 'dart:convert';

import 'package:catalog_app/core/network/api_client.dart';
import 'package:catalog_app/features/catalog/data/models/product_dto.dart';
import 'package:catalog_app/features/catalog/domain/entities/paged_result.dart';
import 'package:catalog_app/features/catalog/domain/entities/product.dart';
import 'package:catalog_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;
  static const _cacheTtl = Duration(hours: 12);
  static const _boxName = 'catalog_cache';

  @override
  Future<PagedResult<Product>> fetchProducts({
    required int skip,
    required int limit,
    String query = '',
    String? category,
  }) async {
    final cleanedQuery = query.trim();

    final String path;
    final queryParams = <String, String>{'skip': '$skip', 'limit': '$limit'};

    if (cleanedQuery.isNotEmpty) {
      path = '/products/search';
      queryParams['q'] = cleanedQuery;
    } else if (category != null && category.isNotEmpty) {
      path = '/products/category/${Uri.encodeComponent(category)}';
    } else {
      path = '/products';
    }

    final cacheKey = _productsCacheKey(path, queryParams, category: category);

    try {
      final json = await _apiClient.get(path, query: queryParams);
      await _saveCache(cacheKey, json);
      return _mapPagedProducts(
        json,
        limit: limit,
        skip: skip,
        query: cleanedQuery,
        category: category,
        isFromCache: false,
      );
    } catch (_) {
      final cached = await _readCache(cacheKey);
      if (cached != null && !_isExpired(cached.cachedAt)) {
        return _mapPagedProducts(
          cached.payload,
          limit: limit,
          skip: skip,
          query: cleanedQuery,
          category: category,
          isFromCache: true,
          cachedAtEpochMs: cached.cachedAt.millisecondsSinceEpoch,
        );
      }
      rethrow;
    }
  }

  @override
  Future<List<String>> fetchCategories() async {
    const cacheKey = 'catalog:categories';
    try {
      final json = await _apiClient.get('/products/categories');
      await _saveCache(cacheKey, json);
      return _mapCategories(json);
    } catch (_) {
      final cached = await _readCache(cacheKey);
      if (cached != null && !_isExpired(cached.cachedAt)) {
        return _mapCategories(cached.payload);
      }
      rethrow;
    }
  }

  @override
  Future<Product> fetchProductById(int id) async {
    final cacheKey = 'catalog:product:$id';
    try {
      final json = await _apiClient.get('/products/$id');
      await _saveCache(cacheKey, json);
      return ProductDto.fromJson(Map<String, dynamic>.from(json as Map));
    } catch (_) {
      final cached = await _readCache(cacheKey);
      if (cached != null && !_isExpired(cached.cachedAt)) {
        return ProductDto.fromJson(
          Map<String, dynamic>.from(cached.payload as Map),
        );
      }
      rethrow;
    }
  }

  PagedResult<Product> _mapPagedProducts(
    dynamic json, {
    required int limit,
    required int skip,
    required String query,
    required String? category,
    required bool isFromCache,
    int? cachedAtEpochMs,
  }) {
    final productsJson = (json['products'] as List<dynamic>? ?? []);
    final products = productsJson
        .whereType<Map<String, dynamic>>()
        .map(ProductDto.fromJson)
        .where((item) {
          if (query.isNotEmpty && category != null && category.isNotEmpty) {
            return item.category.toLowerCase() == category.toLowerCase();
          }
          return true;
        })
        .toList(growable: false);

    return PagedResult<Product>(
      items: products,
      total: (json['total'] as num?)?.toInt() ?? products.length,
      limit: (json['limit'] as num?)?.toInt() ?? limit,
      skip: (json['skip'] as num?)?.toInt() ?? skip,
      isFromCache: isFromCache,
      cachedAtEpochMs: cachedAtEpochMs,
    );
  }

  List<String> _mapCategories(dynamic json) {
    if (json is! List) {
      return const [];
    }

    return json
        .map((item) {
          if (item is String) return item;
          if (item is Map<String, dynamic>) {
            return (item['name'] ?? item['slug'] ?? '').toString();
          }
          return '';
        })
        .where((item) => item.trim().isNotEmpty)
        .map((item) => item.trim())
        .toSet()
        .toList()
      ..sort();
  }

  String _productsCacheKey(
    String path,
    Map<String, String> query, {
    String? category,
  }) {
    return 'catalog:products:$path:skip=${query['skip']}:limit=${query['limit']}:q=${query['q'] ?? ''}:category=${category ?? ''}';
  }

  bool _isExpired(DateTime cachedAt) {
    return DateTime.now().difference(cachedAt) > _cacheTtl;
  }

  Future<void> _saveCache(String key, dynamic payload) async {
    final box = Hive.box<dynamic>(_boxName);
    final data = jsonEncode({
      'cachedAt': DateTime.now().millisecondsSinceEpoch,
      'payload': payload,
    });
    await box.put(key, data);
  }

  Future<_CacheRecord?> _readCache(String key) async {
    final box = Hive.box<dynamic>(_boxName);
    final raw = box.get(key) as String?;
    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final cachedAtEpochMs = (decoded['cachedAt'] as num?)?.toInt();
      final payload = decoded['payload'];
      if (cachedAtEpochMs == null || payload == null) {
        return null;
      }
      return _CacheRecord(
        payload: payload,
        cachedAt: DateTime.fromMillisecondsSinceEpoch(cachedAtEpochMs),
      );
    } catch (_) {
      return null;
    }
  }
}

class _CacheRecord {
  const _CacheRecord({required this.payload, required this.cachedAt});

  final dynamic payload;
  final DateTime cachedAt;
}
