
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:crud_bloc/core/common/firebase_constants.dart';
import 'package:crud_bloc/features/widget%20bloc/search_bloc.dart';
import 'package:crud_bloc/features/widget%20bloc/widget_bloc.dart';
import 'package:crud_bloc/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../widget bloc/image_bloc.dart';
import '../repository/product_repository.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  ProductBloc(this._productRepository) : super(ProductInitial()) {
    on<AddProduct>((event, emit)async{
      emit(AddProductLoading(loading: true));
      final image= await storeFile(path: 'products/${event.productName}',
          file: event.file);
      await _productRepository.addProduct(productName: event.productName, available: event.available,
          mrp: event.mrp, details: event.details, category: event.category, stock: event.stock,
          image: image).then((value){
        // emit(AddProductLoading(loading: false));
        Future.delayed( const Duration(milliseconds: 500),(){
          Navigator.pop(event.context);
          event.context.read<ImagePickerBloc>().add(GalleryImagePickerExited());
        });
      }).onError((error, stackTrace){
        emit(AddProductLoading(loading: false));
      });
    });

    on<FetchProducts>((event, emit)async{
      emit(ProductLoadingState());
      try{
      await  emit.forEach(_productRepository.getProducts(search: event.search??""), onData: (List<ProductList> product){
        return ReadProductsState(products: product);
      });
      }catch(e,s){
        print(e);
        print(s);
        emit(ProductsError(error: e.toString()));
      }
    });

    on<UpdateProduct>((event, emit)async{
      // emit(UpdateProductLoading(loading: true));
      String image="";
      if(event.file != null) {
         image = await storeFile(path: 'products/${event.productName}',
            file: event.file);
      }
      await _productRepository.updateProduct(
          productName: event.productName, available: event.available,
          product: event.product, mrp: event.mrp, details: event.details,
          category: event.category, stock: event.stock,
          image:event.file==null?event.image:image).then((value){
        // emit(UpdateProductLoading(loading: false));
        Future.delayed( const Duration(milliseconds: 200),(){
          Navigator.pop(event.context);
          event.context.read<ImagePickerBloc>().add(GalleryImagePickerExited());
          event.context.read<DropDownBloc>().add(DropDownChanged(null));
        });
      }).onError((error, stackTrace) {
        // emit(UpdateProductLoading(loading: false));
      });
    });
    // on<FetchProducts>((event, emit)async{
    //   emit(ProductLoadingState());
    //   await _productRepository.getProducts().then((value){
    //     emit(ReadProductsState(products: value));
    //   }).onError((error, stackTrace) {
    //     print(error);
    //     print(stackTrace);
    //     emit(ProductsError(error: error.toString()));
    //   });
    // });

    // Stream<ProductState> mapFetchProductsToState() async* {
    //   try {
    //     final users = await _productRepository.getUsers();
    //     yield ProductsLoaded(users);
    //   } catch (e) {
    //     yield ProductsError(e.toString());
    //   }
    // }
    //
    // Stream<ProductState> mapAddProductToState({required String productName,required bool available,
    //   required double mrp,required String details,required String category,required int stock}) async* {
    //   try {
    //     await _productRepository.addProduct(productName: productName, available: available,
    //         mrp: mrp, details: details, category: category, stock: stock);
    //     final updatedUsers = await _productRepository.getUsers();
    //     yield ProductsLoaded(updatedUsers);
    //   } catch (e) {
    //     yield ProductsError(e.toString());
    //   }
    // }
    //
    // Stream<ProductState> mapUpdateProductToState(ProductList product) async* {
    //   try {
    //     await _productRepository.updateProduct(product);
    //     final updatedUsers = await _productRepository.getUsers();
    //     yield ProductsLoaded(updatedUsers);
    //   } catch (e) {
    //     yield ProductsError(e.toString());
    //   }
    // }
    //
    // Stream<ProductState> mapDeleteProductToState(String userId) async* {
    //   try {
    //     await _productRepository.deleteUser(userId);
    //     final updatedUsers = await _productRepository.getUsers();
    //     yield ProductsLoaded(updatedUsers);
    //   } catch (e) {
    //     yield ProductsError(e.toString());
    //   }
    // }
    //
    // @override
    // Stream<ProductState> mapEventToState(ProductEvent event) async* {
    //   if (event is FetchProducts) {
    //     yield* mapFetchProductsToState();
    //   } else if (event is AddProduct) {
    //     yield* mapAddProductToState(
    //         productName:event.productName, available: event.available,
    //         mrp: event.mrp, details: event.details, category: event.category,
    //         stock: event.stock);
    //   } else if (event is UpdateProduct) {
    //     yield* mapUpdateProductToState(event.product);
    //   } else if (event is DeleteProduct) {
    //     yield* mapDeleteProductToState(event.userId);
    //   }
    // }

  }
}
// class UserBloc extends Bloc<UserEvent, UserState> {
//   final UserRepository _userRepository;
//
//   UserBloc(this._userRepository) : super(UserInitial());
//
//   @override
//   Stream<UserState> mapEventToState(UserEvent event) async* {
//     if (event is FetchUsers) {
//       yield* _mapFetchUsersToState();
//     } else if (event is AddUser) {
//       yield* _mapAddUserToState(event.user);
//     } else if (event is UpdateUser) {
//       yield* _mapUpdateUserToState(event.user);
//     } else if (event is DeleteUser) {
//       yield* _mapDeleteUserToState(event.userId);
//     }
//   }
//
//   Stream<UserState> _mapFetchUsersToState() async* {
//     try {
//       final users = await _userRepository.getUsers();
//       yield UsersLoaded(users);
//     } catch (e) {
//       yield UsersError(e.toString());
//     }
//   }
//
//   Stream<UserState> _mapAddUserToState(User user) async* {
//     try {
//       await _userRepository.createUser(user);
//       final updatedUsers = await _userRepository.getUsers();
//       yield UsersLoaded(updatedUsers);
//     } catch (e) {
//       yield UsersError(e.toString());
//     }
//   }
//
//   Stream<UserState> _mapUpdateUserToState(User user) async* {
//     try {
//       await _userRepository.updateUser(user);
//       final updatedUsers = await _userRepository.getUsers();
//       yield UsersLoaded(updatedUsers);
//     } catch (e) {
//       yield UsersError(e.toString());
//     }
//   }
//
//   Stream<UserState> _mapDeleteUserToState(String userId) async* {
//     try {
//       await _userRepository.deleteUser(userId);
//       final updatedUsers = await _userRepository.getUsers();
//       yield UsersLoaded(updatedUsers);
//     } catch (e) {
//       yield UsersError(e.toString());
//     }
//   }
// }
