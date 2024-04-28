part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class FetchProducts extends ProductEvent {
  final String? search;
  FetchProducts(this.search);
}

class AddProduct extends ProductEvent {
  final String productName;
  final double mrp;
  final int stock;
  final bool available;
  final String details;
  final String category;
  final File file;
  final BuildContext context;
  AddProduct({required this.productName,required this.available,required this.context,
    required this.mrp,required this.details,required this.category,required this.stock,
  required this.file});
}

class UpdateProduct extends ProductEvent {
  final ProductList product;
  final String productName;
  final double mrp;
  final int stock;
  final bool available;
  final String details;
  final String category;
  final BuildContext context;
  final File? file;
  final String image;
  UpdateProduct({required this.productName,required this.available,required this.context,
    required this.mrp,required this.details,required this.category,required this.stock,
    required this.product,required this.file,required this.image});
}

class DeleteProduct extends ProductEvent {
  final String userId;

  DeleteProduct(this.userId);
}

