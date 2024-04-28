import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel{
  String name;
  String id;
  bool delete;
  DocumentReference reference;
  List search;
  bool active;

  CategoryModel({
    required this.name,
    required this.id,
    required this.delete,
    required this.reference,
    required this.search,
    required this.active,
  });
  CategoryModel copyWith({
    String? name,
    String? id,
    String? image,
    bool? delete,
    bool? active,
    DocumentReference? reference,
    List? search,
  })=>
      CategoryModel
        (name: name?? this.name,
        id: id?? this.id,
        delete: delete?? this.delete,
        reference: reference?? this.reference,
        search: search?? this.search,
        active: active?? this.active,
      );
  factory CategoryModel.fromjson(dynamic json)=>CategoryModel(
      name: json["name"],
      id: json["id"],
      delete: json["delete"],
      reference: json["reference"],
    search: json["search"],
    active: json["active"],
  );
  Map<String,dynamic> toJson()=>{
    "name":name,
    "id":id,
    "delete":delete,
    "reference":reference,
    "search":search,
    "active":active,
  };
}