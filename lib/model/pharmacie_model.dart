import 'package:cloud_firestore/cloud_firestore.dart';

class PharmacieModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String startTime;
  final String endTime;
  final List<String> workDays;
  final GeoPoint? location;

  PharmacieModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.startTime,
    required this.endTime,
    required this.workDays,
    this.location,
  });

  factory PharmacieModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PharmacieModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      workDays: List<String>.from(data['workDays'] ?? []),
      location: data['location'],
    );
  }
}
