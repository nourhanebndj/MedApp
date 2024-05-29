import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  final String name;
  final String email;
  final List<String> category;
  final String phone;
  final String startTime;
  final String endTime;
  final List<String> workDays;
  final GeoPoint? location;
  final String doctorId;

  DoctorModel({
    required this.doctorId,
    required this.name,
    required this.category,
    required this.email,
    required this.phone,
    required this.startTime,
    required this.endTime,
    required this.workDays,
    this.location,
  });

  factory DoctorModel.fromFirestore(Map<String, dynamic> firestoreData) {
    // Handle null, single string categories, and lists, ensuring result is always a list.
    var categoryData = firestoreData['category'];
    List<String> categoryList;
    if (categoryData == null) {
      categoryList = []; // Handle null explicitly
    } else if (categoryData is String) {
      categoryList = [categoryData]; // Make a single string a list
    } else if (categoryData is List) {
      categoryList = categoryData.map((e) => e.toString()).toList(); // Ensure all elements are strings
    } else {
      categoryList = []; // Default to an empty list for any other unexpected type
    }

    // Extract latitude and longitude from GeoPoint if not null
    GeoPoint? geoPoint = firestoreData['location'];
    double? latitude;
    double? longitude;

    if (geoPoint != null) {
      latitude = geoPoint.latitude;
      longitude = geoPoint.longitude;
    }

    return DoctorModel(
      name: firestoreData['name'] as String? ?? '',
      email: firestoreData['email'] as String? ?? '',
      doctorId: firestoreData['doctorId'] as String? ?? '',
      category: categoryList,
      phone: firestoreData['phone'] as String? ?? '',
      startTime: firestoreData['startTime'] as String? ?? '',
      endTime: firestoreData['endTime'] as String? ?? '',
      workDays: List<String>.from(firestoreData['workDays'] ?? []),
      location: (latitude != null && longitude != null) ? GeoPoint(latitude, longitude) : null, // Initialize location as nullable GeoPoint
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'name': name,
      'email': email,
      'category': category,
      'phone': phone,
      'startTime': startTime,
      'endTime': endTime,
      'workDays': workDays,
      'doctorId': doctorId,
    };
  }
}
