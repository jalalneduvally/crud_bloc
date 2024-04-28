import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_bloc/models/product_model.dart';

import '../../../core/common/firebase_constants.dart';
import '../../../core/common/search.dart';

class ProductRepository {
   CollectionReference get _product => FirebaseFirestore.instance.collection(Constants.product);


    Stream<List<ProductList>> getProducts({required String search}){
     return search.isEmpty?_product
         .where('delete', isEqualTo: false).orderBy('date', descending: true)
         .snapshots().map((event) => event.docs
         .map((e) => ProductList.fromJson( e.data() as Map<String, dynamic>,),).toList(),
     ):_product
         .where('delete', isEqualTo: false).orderBy('date', descending: true)
         .where('search', arrayContains: search.toUpperCase().trim())
         .snapshots().map((event) => event.docs
         .map((e) => ProductList.fromJson( e.data() as Map<String, dynamic>,),).toList(),
     );
   }

  // Future<List<ProductList>> getProducts() async {
  //   QuerySnapshot snapshot = await _product.get();
  //   List<ProductList> prod =[];
  //   for(var a in snapshot.docs){
  //     prod.add(ProductList.fromJson(a.data() as Map<String,dynamic>));
  //   }
  //   // return snapshot.docs.map((doc) => ProductList.fromJson(doc.data() as Map<String,dynamic>)).toList();
  //   return prod;
  // }

  Future<void> addProduct({required String productName,required bool available,required String image,
  required double mrp,required String details,required String category,required int stock}) async {
    DocumentReference reference=_product.doc();
    ProductList product= ProductList(
        productName: productName, delete: false,
        available: available, image: image,
        id: reference.id, details: details, category: category,
        date: DateTime.now(), reference: reference, mrp: mrp,
        stock: stock, search: setSearchParam(productName.toUpperCase().trim()));
    await _product.doc(reference.id).set(product.toJson());
  }

  Future<void> updateProduct({required String productName,required bool available,required ProductList product,
    required double mrp,required String details,required String category,required int stock,
  required String image}) async {
      ProductList r=product.copyWith(
        stock: stock,
        image: image,
        search:setSearchParam(productName.toUpperCase().trim()),
        mrp: mrp, productName: productName,
        available: available, category: category, details: details,
      );
    await product.reference.update(r.toJson());
  }

  Future<void> deleteUser(String userId) async {
    await _product.doc(userId).delete();
  }
}