import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_bloc/models/category_model.dart';

import '../../../core/common/firebase_constants.dart';
import '../../../core/common/search.dart';

class CategoryRepository{

  Stream<List<CategoryModel>> getCategories(){
    return _category
        .where('delete', isEqualTo: false)
        .snapshots().map((event) => event.docs
        .map((e) => CategoryModel.fromjson( e.data() as Map<String, dynamic>,),).toList(),
    );
  }

  Future<void> addCategory({required String name,required bool active}) async {
    DocumentReference reference=_category.doc();
    CategoryModel product= CategoryModel(
        name: name, id: reference.id,
        delete: false, reference: reference,
        search: setSearchParam(name.toUpperCase().trim()),
        active: active);
    await _category.doc(reference.id).set(product.toJson());
  }

  Future<void> updateCategory({required String name,required bool active,required CategoryModel category}) async {
    CategoryModel r=category.copyWith(
      name: name,
      active: active,
      search:setSearchParam(name.toUpperCase().trim()),
    );
    await category.reference.update(r.toJson());
  }

  CollectionReference get _category => FirebaseFirestore.instance.collection(Constants.category);
}