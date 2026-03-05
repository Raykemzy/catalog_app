import 'package:catalog_app/features/catalog/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

enum ProductListStatus { initial, loading, success, empty, error }

class ProductListState extends Equatable {
  const ProductListState({
    this.status = ProductListStatus.initial,
    this.products = const [],
    this.categories = const [],
    this.query = '',
    this.selectedCategory,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.skip = 0,
    this.total = 0,
    this.isFromCache = false,
    this.cacheTimestampEpochMs,
  });

  final ProductListStatus status;
  final List<Product> products;
  final List<String> categories;
  final String query;
  final String? selectedCategory;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? errorMessage;
  final int skip;
  final int total;
  final bool isFromCache;
  final int? cacheTimestampEpochMs;

  ProductListState copyWith({
    ProductListStatus? status,
    List<Product>? products,
    List<String>? categories,
    String? query,
    String? selectedCategory,
    bool clearCategory = false,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? errorMessage,
    bool clearError = false,
    int? skip,
    int? total,
    bool? isFromCache,
    int? cacheTimestampEpochMs,
    bool clearCacheTimestamp = false,
  }) {
    return ProductListState(
      status: status ?? this.status,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      query: query ?? this.query,
      selectedCategory: clearCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      skip: skip ?? this.skip,
      total: total ?? this.total,
      isFromCache: isFromCache ?? this.isFromCache,
      cacheTimestampEpochMs: clearCacheTimestamp
          ? null
          : (cacheTimestampEpochMs ?? this.cacheTimestampEpochMs),
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    categories,
    query,
    selectedCategory,
    hasMore,
    isLoadingMore,
    isRefreshing,
    errorMessage,
    skip,
    total,
    isFromCache,
    cacheTimestampEpochMs,
  ];
}
