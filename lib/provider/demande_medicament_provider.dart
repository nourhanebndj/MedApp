import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mediloc/model/Demande_des_medicament_model.dart';

class NotificationCustom {
  final String message;
  final DateTime timestamp;

  NotificationCustom({
    required this.message,
    required this.timestamp,
  });
}

class DemandeMedicamentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Demande_Disponibilite> _demandesMedicament = [];
  bool _isLoading = false;
  List<NotificationCustom> _notifications = [];

  List<Demande_Disponibilite> get demandesMedicament => _demandesMedicament;
  bool get isLoading => _isLoading;
  List<NotificationCustom> get notifications => _notifications;

  Future<void> loadDemandesMedicament(String pharmacieId) async {
    try {
      _isLoading = true;
      notifyListeners();

      QuerySnapshot querySnapshot = await _firestore
          .collection('Demande_medicament')
          .where('pharmacieId', isEqualTo: pharmacieId)
          .get();

      _demandesMedicament = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        String userId = doc.id;
        String firstName = data['firstName'] ?? '';
        String age = data['Age'] ?? '';
        String text = data['text'] ?? '';
        String statut = data['status'] ?? '';
        String? rejectionNote = data['note'];

        NotificationCustom notification = NotificationCustom(
          message: "New medication request received.",
          timestamp: DateTime.now(),
        );
        _notifications.add(notification);

        return Demande_Disponibilite(
          userId: userId,
          pharmacieId: pharmacieId,
          firstName: firstName,
          age: age,
          text: text,
          statut: statut,
          note: rejectionNote,
        );
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error loading medication requests: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateDemandeMedicamentStatus(
    Demande_Disponibilite demande, String newStatus,
    {String? note}) async {
  try {
    Map<String, dynamic> updateData = {'status': newStatus};
    if (newStatus == 'rejected') {
      updateData['note'] = note;

      // Ajoute la notification avec la note
      String message = "Your request has been rejected. Note: $note";
      NotificationCustom notification = NotificationCustom(
        message: message,
        timestamp: DateTime.now(),
      );
      _notifications.add(notification);
      notifyListeners();
    } else if (newStatus == 'accepted') {
      updateData['note'] = '';
      
      // Ajoute la notification
      String message = "Your request has been accepted.Note:$note";
      NotificationCustom notification = NotificationCustom(
        message: message,
        timestamp: DateTime.now(),
      );
      _notifications.add(notification);
      notifyListeners();
    }

    await FirebaseFirestore.instance
        .collection('Demande_medicament')
        .doc(demande.userId)
        .update(updateData);

    int index =
        _demandesMedicament.indexWhere((dem) => dem.userId == demande.userId);
    if (index != -1) {
      _demandesMedicament[index].statut = newStatus;
      notifyListeners();
    }
  } catch (e) {
    print("Error updating medication request status: $e");
  }
}



  void saveNote(Demande_Disponibilite demande, String note) async {
    try {
      await FirebaseFirestore.instance
          .collection('Demande_medicament')
          .doc(demande.userId)
          .update({'note': note});

      int index = _demandesMedicament
          .indexWhere((dem) => dem.userId == demande.userId);
      if (index != -1) {
        _demandesMedicament[index].note = note;
        notifyListeners();
      }

      print('Note saved successfully.');
    } catch (e) {
      print('Error saving note: $e');
    }
  }

  void markNotificationAsRead(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications.removeAt(index);
      notifyListeners();
    }
  }

  List<NotificationCustom> getNotifications() {
    return _notifications;
  }
}
