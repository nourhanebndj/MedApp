import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mediloc/model/category_model.dart';

class Myprovider with ChangeNotifier {
  List<CategoryModel> categoryModelList = [];

  Future<void> getCategory() async {
    List<CategoryModel> list = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("categories").get();
    querySnapshot.docs.forEach((categorydata) {
      dynamic data = categorydata.data();
      if (data != null) {
        CategoryModel categoryModel = CategoryModel(
          name: data["name"] as String,
          image: data["image"] as String,
        );
        list.add(categoryModel);
      }
    });
    categoryModelList = list;
  }

  List<CategoryModel> get getCategoryModelList {
    return categoryModelList;
  }
}
