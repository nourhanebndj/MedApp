import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mediloc/model/category_laboratory.dart';

class Myproviderlaboratory with ChangeNotifier {
  List<CategorylaboratoryModel> categorylaboratoryModelList = [];

  Future<void> getCategorylaboratoire() async {
    List<CategorylaboratoryModel> list = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("laboratoire_categorie").get();
    querySnapshot.docs.forEach((categorydata) {
      dynamic data = categorydata.data();
      if (data != null) {
        CategorylaboratoryModel category = CategorylaboratoryModel(
          name: data["name"] as String,
          image: data["image"] as String,
        );
        list.add(category);
      }
    });
    categorylaboratoryModelList = list;
  }
  

  List<CategorylaboratoryModel> get getCategorylaboratoryModelList {
    return categorylaboratoryModelList;
  }
}
