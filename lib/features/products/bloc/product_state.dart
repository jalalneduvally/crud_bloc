part of 'product_bloc.dart';


abstract class ProductState {}

final class ProductInitial extends ProductState {}

class ProductLoadingState extends ProductState{}

class ReadProductsState extends ProductState {
  final List<ProductList> products;
  ReadProductsState({required this.products});
}

class ProductsError extends ProductState {
  final String error;
  ProductsError({required this.error});
}

class AddProductLoading extends ProductState{
  bool loading;
  AddProductLoading({required this.loading});
}
class UpdateProductLoading extends ProductState{
  bool loading;
  UpdateProductLoading({required this.loading});
}
