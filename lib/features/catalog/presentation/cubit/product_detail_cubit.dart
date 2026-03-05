import 'package:catalog_app/features/catalog/domain/entities/product.dart';
import 'package:catalog_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ProductDetailStatus { initial, loading, loaded, error }

class ProductDetailState extends Equatable {
  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.message,
  });

  final ProductDetailStatus status;
  final Product? product;
  final String? message;

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    Product? product,
    String? message,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, product, message];
}

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({required CatalogRepository repository})
    : _repository = repository,
      super(const ProductDetailState());

  final CatalogRepository _repository;

  Future<void> load(int id) async {
    if (isClosed) return;
    emit(state.copyWith(status: ProductDetailStatus.loading));
    try {
      final product = await _repository.fetchProductById(id);
      if (isClosed) return;
      emit(
        state.copyWith(status: ProductDetailStatus.loaded, product: product),
      );
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: ProductDetailStatus.error,
          message: error.toString(),
        ),
      );
    }
  }
}
