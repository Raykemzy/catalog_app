import 'package:bloc_test/bloc_test.dart';
import 'package:catalog_app/features/catalog/domain/entities/product.dart';
import 'package:catalog_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:catalog_app/features/catalog/presentation/cubit/product_detail_cubit.dart';
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

  setUp(() {
    repository = _MockCatalogRepository();
  });

  blocTest<ProductDetailCubit, ProductDetailState>(
    'emits loading then loaded on successful fetch',
    build: () {
      when(
        () => repository.fetchProductById(1),
      ).thenAnswer((_) async => sampleProduct);
      return ProductDetailCubit(repository: repository);
    },
    act: (cubit) => cubit.load(1),
    expect: () => [
      const ProductDetailState(status: ProductDetailStatus.loading),
      const ProductDetailState(
        status: ProductDetailStatus.loaded,
        product: sampleProduct,
      ),
    ],
  );

  blocTest<ProductDetailCubit, ProductDetailState>(
    'emits loading then error on failure',
    build: () {
      when(() => repository.fetchProductById(1)).thenThrow(Exception('failed'));
      return ProductDetailCubit(repository: repository);
    },
    act: (cubit) => cubit.load(1),
    expect: () => [
      const ProductDetailState(status: ProductDetailStatus.loading),
      isA<ProductDetailState>()
          .having((s) => s.status, 'status', ProductDetailStatus.error)
          .having((s) => s.message != null, 'message', true),
    ],
  );
}
