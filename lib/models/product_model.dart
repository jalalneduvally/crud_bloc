

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductList {

  String productName;
  double mrp;
  int stock;
  bool delete;
  bool available;
  String image;
  String id;
  String details;
  String category;
  DateTime date;
  DocumentReference reference;
  List search;

  ProductList({
    required this.productName,
    required this.delete,
    required this.available,
    required this.image,
    required this.id,
    required this.details,
    required this.category,
    required this.date,
    required this.reference,
    required this.mrp,
    required this.stock,
    required this.search,
  });

  ProductList copyWith({
    String? productName,
    bool? delete,
    bool? available,
    double? mrp,
    int? stock,
    String? image,
    String? id,
    String? details,
    String? category,
    DateTime? date,
    DocumentReference? reference,
    List? search,
  }) =>
      ProductList(
        productName: productName ?? this.productName,
        delete: delete ?? this.delete,
        id: id ?? this.id,
        date: date ?? this.date,
        details: details ?? this.details,
        reference: reference?? this.reference,
        image: image ?? this.image,
        available: available ?? this.available,
        category: category ?? this.category,
        stock: stock ?? this.stock,
        mrp: mrp ?? this.mrp,
        search: search ?? this.search,
      );

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
    productName: json["productName"]??"",
    delete: json["delete"],
    image: json["image"]??"",
    id: json["id"],
    date: json["date"].toDate(),
    reference: json["reference"],
    details: json["details"]??"",
    available: json["available"],
    category: json["category"]??"",
    mrp: double.tryParse(json["mrp"].toString())??0,
    stock: json["stock"]??0,
    search: json["search"]??[],
  );

  Map<String, dynamic> toJson() => {
    "productName": productName,
    "delete":delete,
    "image":image,
    "id":id,
    "details":details,
    "date":date,
    "reference":reference,
    "available":available,
    "category":category,
    "stock":stock,
    "mrp":mrp,
    "search":search,
  };
}