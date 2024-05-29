import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class laboratoryModel {
  final String name, email, phone, startTime, endTime, laboratoryId;
  final List<String> category, workDays;
  final GeoPoint? location;

  laboratoryModel({
    required this.laboratoryId,
    required this.name,
    required this.email,
    required this.phone,
    required this.startTime,
    required this.endTime,
    required this.category,
    required this.workDays,
    this.location,
  });

  factory laboratoryModel.fromFirestore(Map<String, dynamic> firestoreData) {
    List<String> categoryList = [];
    try {
      var categoryData = firestoreData['category'];
      if (categoryData is String) {
        categoryList = [categoryData];
      } else if (categoryData is List) {
        categoryList = categoryData.map((e) => e.toString()).toList();
      }
    } catch (e) {
      debugPrint('Error processing categories: $e');
    }

    GeoPoint? geoPoint = firestoreData['location'];
    double? latitude;
    double? longitude;
    if (geoPoint != null) {
      latitude = geoPoint.latitude;
      longitude = geoPoint.longitude;
    }

    return laboratoryModel(
      laboratoryId: firestoreData['laboratoryId'] as String? ?? '',
      name: firestoreData['name'] as String? ?? '',
      email: firestoreData['email'] as String? ?? '',
      phone: firestoreData['phone'] as String? ?? '',
      startTime: firestoreData['startTime'] as String? ?? '',
      endTime: firestoreData['endTime'] as String? ?? '',
      workDays: List<String>.from(firestoreData['workDays'] ?? []),
      category: categoryList,
      location: (latitude != null && longitude != null) ? GeoPoint(latitude, longitude) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'laboratoryId': laboratoryId,
      'name': name,
      'email': email,
      'phone': phone,
      'startTime': startTime,
      'endTime': endTime,
      'category': category,
      'workDays': workDays,
      'location':location,
    };
  }
}
