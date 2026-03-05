import 'dart:async';

import 'package:catalog_app/core/constants/app_constants.dart';
import 'package:catalog_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:catalog_app/features/catalog/presentation/cubit/product_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListCubit extends Cubit<ProductListState> {
  ProductListCubit({required CatalogRepository repository})
    : _repository = repository,
      super(const ProductListState());

  final CatalogRepository _repository;
  Timer? _debounce;

  Future<void> initialize() async {
    await Future.wait([_loadCategories(), refresh()]);
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _repository.fetchCategories();
      emit(state.copyWith(categories: categories));
    } catch (_) {
      emit(state.copyWith(categories: const []));
    }
  }

  void updateQuery(String value) {
    _debounce?.cancel();
    emit(state.copyWith(query: value));

    _debounce = Timer(const Duration(milliseconds: 350), () {
      refresh();
    });
  }

  Future<void> updateCategory(String? category) async {
    emit(
      state.copyWith(
        selectedCategory: category,
        clearCategory: category == null,
      ),
    );
    await refresh();
  }

  Future<void> refresh() async {
    final hasExistingItems = state.products.isNotEmpty;
    emit(
      state.copyWith(
        status: hasExistingItems
            ? ProductListStatus.success
            : ProductListStatus.loading,
        products: hasExistingItems ? state.products : const [],
        hasMore: true,
        skip: 0,
        total: 0,
        isRefreshing: hasExistingItems,
        clearError: true,
        isFromCache: false,
        clearCacheTimestamp: true,
      ),
    );

    await _loadPage(reset: true);

    if (state.products.isEmpty &&
        state.hasMore &&
        state.query.isNotEmpty &&
        state.selectedCategory != null) {
      for (var i = 0; i < 3; i++) {
        if (!state.hasMore || state.products.isNotEmpty) break;
        await _loadPage();
      }
    }
  }

  Future<void> loadNextPage() async {
    if (state.isLoadingMore ||
        !state.hasMore ||
        state.status == ProductListStatus.loading) {
      return;
    }
    await _loadPage();
  }

  Future<void> retry() => refresh();

  Future<void> _loadPage({bool reset = false}) async {
    try {
      if (!reset) {
        emit(state.copyWith(isLoadingMore: true, clearError: true));
      }

      final result = await _repository.fetchProducts(
        skip: reset ? 0 : state.skip,
        limit: AppConstants.pageLimit,
        query: state.query,
        category: state.selectedCategory,
      );

      final updatedItems = reset
          ? result.items
          : [
              ...state.products,
              ...result.items.where((item) => !state.products.contains(item)),
            ];

      final status = updatedItems.isEmpty
          ? ProductListStatus.empty
          : ProductListStatus.success;

      emit(
        state.copyWith(
          status: status,
          products: updatedItems,
          hasMore: result.hasMore,
          isLoadingMore: false,
          isRefreshing: false,
          skip: result.skip + result.limit,
          total: result.total,
          isFromCache: result.isFromCache,
          cacheTimestampEpochMs: result.cachedAtEpochMs,
          clearError: true,
        ),
      );
    } catch (error) {
      final hasData = state.products.isNotEmpty;
      emit(
        state.copyWith(
          status: hasData ? ProductListStatus.success : ProductListStatus.error,
          isLoadingMore: false,
          isRefreshing: false,
          errorMessage: hasData ? state.errorMessage : error.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
