import 'package:bloc_test/bloc_test.dart';
import 'package:catalog_app/features/catalog/domain/entities/paged_result.dart';
import 'package:catalog_app/features/catalog/domain/entities/product.dart';
import 'package:catalog_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:catalog_app/features/catalog/presentation/cubit/product_list_cubit.dart';
import 'package:catalog_app/features/catalog/presentation/cubit/product_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCatalogRepository extends Mock implements CatalogRepository {}

void main() {
  late CatalogRepository repository;

  const sampleProduct = Product(
    id: 1,
    title: 'Phone',
    description: 'Desc',
    price: 100,
    discountPercentage: 10,
    rating: 4.5,
    stock: 12,
    brand: 'Brand',
    category: 'smartphones',
    thumbnail: 'https://example.com/p.png',
    images: ['https://example.com/p.png'],
  );
  const pageTwoProduct = Product(
    id: 2,
    title: 'Laptop',
    description: 'Desc',
    price: 200,
    discountPercentage: 0,
    rating: 4,
    stock: 5,
    brand: 'Brand2',
    category: 'laptops',
    thumbnail: 'https://example.com/l.png',
    images: ['https://example.com/l.png'],
  );

  setUp(() {
    repository = _MockCatalogRepository();
  });

  blocTest<ProductListCubit, ProductListState>(
    'initialize emits loading then success state',
    build: () {
      when(
        () => repository.fetchCategories(),
      ).thenAnswer((_) async => ['smartphones']);
      when(
        () => repository.fetchProducts(
          skip: any(named: 'skip'),
          limit: any(named: 'limit'),
          query: any(named: 'query'),
          category: any(named: 'category'),
        ),
      ).thenAnswer(
        (_) async => const PagedResult(
          items: [sampleProduct],
          total: 1,
          limit: 20,
          skip: 0,
        ),
      );

      return ProductListCubit(repository: repository);
    },
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const ProductListState(status: ProductListStatus.loading),
      const ProductListState(
        status: ProductListStatus.loading,
        categories: ['smartphones'],
      ),
      const ProductListState(
        status: ProductListStatus.success,
        categories: ['smartphones'],
        products: [sampleProduct],
        hasMore: false,
        skip: 20,
        total: 1,
      ),
    ],
  );

  blocTest<ProductListCubit, ProductListState>(
    'emits error when initial request fails',
    build: () {
      when(() => repository.fetchCategories()).thenAnswer((_) async => []);
      when(
        () => repository.fetchProducts(
          skip: any(named: 'skip'),
          limit: any(named: 'limit'),
          query: any(named: 'query'),
          category: any(named: 'category'),
        ),
      ).thenThrow(Exception('network failure'));

      return ProductListCubit(repository: repository);
    },
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const ProductListState(status: ProductListStatus.loading),
      isA<ProductListState>()
          .having((s) => s.status, 'status', ProductListStatus.error)
          .having((s) => s.errorMessage != null, 'has message', true),
    ],
  );

  blocTest<ProductListCubit, ProductListState>(
    'refresh emits empty state when no products are returned',
    build: () {
      when(
        () => repository.fetchProducts(
          skip: any(named: 'skip'),
          limit: any(named: 'limit'),
          query: any(named: 'query'),
          category: any(named: 'category'),
        ),
      ).thenAnswer(
        (_) async => const PagedResult(items: [], total: 0, limit: 20, skip: 0),
      );

      return ProductListCubit(repository: repository);
    },
    act: (cubit) => cubit.refresh(),
    expect: () => [
      const ProductListState(status: ProductListStatus.loading),
      const ProductListState(
        status: ProductListStatus.empty,
        products: [],
        hasMore: false,
        skip: 20,
        total: 0,
      ),
    ],
  );

  blocTest<ProductListCubit, ProductListState>(
    'loadNextPage appends items to existing products',
    build: () {
      when(
        () => repository.fetchProducts(
          skip: 0,
          limit: any(named: 'limit'),
          query: any(named: 'query'),
          category: any(named: 'category'),
        ),
      ).thenAnswer(
        (_) async => const PagedResult(
          items: [sampleProduct],
          total: 40,
          limit: 20,
          skip: 0,
        ),
      );

      when(
        () => repository.fetchProducts(
          skip: 20,
          limit: any(named: 'limit'),
          query: any(named: 'query'),
          category: any(named: 'category'),
        ),
      ).thenAnswer(
        (_) async => const PagedResult(
          items: [pageTwoProduct],
          total: 40,
          limit: 20,
          skip: 20,
        ),
      );

      return ProductListCubit(repository: repository);
    },
    act: (cubit) async {
      await cubit.refresh();
      await cubit.loadNextPage();
    },
    expect: () => [
      const ProductListState(status: ProductListStatus.loading),
      const ProductListState(
        status: ProductListStatus.success,
        products: [sampleProduct],
        hasMore: true,
        skip: 20,
        total: 40,
      ),
      const ProductListState(
        status: ProductListStatus.success,
        products: [sampleProduct],
        hasMore: true,
        isLoadingMore: true,
        skip: 20,
        total: 40,
      ),
      const ProductListState(
        status: ProductListStatus.success,
        products: [sampleProduct, pageTwoProduct],
        hasMore: false,
        isLoadingMore: false,
        skip: 40,
        total: 40,
      ),
    ],
  );
}
