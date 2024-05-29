import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/model/medecin_model.dart';
import 'package:mediloc/model/prendre_rendez_vous_model.dart';

class CustomNotification {
  final String message;
  final DateTime timestamp;

  CustomNotification({
    required this.message,
    required this.timestamp,
  });
}

class AppointmentsProvider extends ChangeNotifier {
  List<Appointment> _appointments = [];
  List<CustomNotification> _notifications = [];
  bool _isLoading = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<Appointment> get appointments => _appointments;
  List<CustomNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;

  Future<void> loadAppointmentsForDoctor(String doctorId) async {
    try {
      _isLoading = true;
      notifyListeners();

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Prendre_Rendez_Vous')
          .where('doctorId', isEqualTo: doctorId)
          .get();

      _appointments = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return Appointment(
          userId: doc.id,
          firstName: data['firstName'] ?? '',
          lastName: data['lastName'] ?? '',
          sexe: data['sexe'] ?? '',
          age: data['age'] ?? '',
          selectedDay: data['selectedDay'] ?? '',
          selectedTime: data['selectedTime'] ?? '',
          status: data['status'] ?? '',
          doctorId: doctorId,
        );
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error loading appointments: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateAppointmentStatus(
      Appointment appointment, String newStatus, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('Prendre_Rendez_Vous')
          .doc(appointment.userId)
          .update({'status': newStatus});

      int index = _appointments.indexWhere((apt) => apt.userId == appointment.userId);
      if (index != -1) {
        _appointments[index].status = newStatus;
        notifyListeners();

        DoctorModel? doctor = await _getDoctorDetails(appointment.doctorId);
        CustomNotification notification = CustomNotification(
          message:
              "${S.of(context).Dr} ${doctor?.name} ${S.of(context).appointmentStatusUpdated} $newStatus ${S.of(context).appointement}",
          timestamp: DateTime.now(),
        );
        _notifications.add(notification);
        notifyListeners();       
      }
        } catch (e) {
      print("Error updating appointment status: $e");
    }
  }
  Future<DoctorModel?> _getDoctorDetails(String doctorId) async {
    try {
      DocumentSnapshot doctorSnapshot = await FirebaseFirestore.instance
          .collection('medecin')
          .doc(doctorId)
          .get();

      if (doctorSnapshot.exists) {
        return DoctorModel.fromFirestore(
            doctorSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting doctor details: $e");
      return null;
    }
  }

  void markNotificationAsRead(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications.removeAt(index);
      notifyListeners();
    }
  }

  List<CustomNotification> getNotifications() {
    return _notifications;
  }

  List<CustomNotification> getScheduledNotifications() {
    return _notifications.where((notification) {
      return notification.timestamp.isAfter(DateTime.now());
    }).toList();
  }
}
