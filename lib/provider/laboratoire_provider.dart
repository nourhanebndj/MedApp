import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mediloc/model/laboratory_model.dart';

class LaboratoireProvider with ChangeNotifier {
  List<laboratoryModel> laboratoryModelList = [];
  Position? userPosition;

  Future<void> getlaboratory() async {
    FirebaseFirestore.instance.collection("laboratoire").snapshots().listen(
        (querySnapshot) {
      laboratoryModelList = querySnapshot.docs
          .map((doc) =>
              laboratoryModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    }, onError: (error) {
      print("Erreur lors du chargement des médecins: $error");
    });
  }

  Future<void> getNearestlaboratory() async {
    print("Début de la recherche des médecins les plus proches");
    try {
      List<laboratoryModel> newList = [];
      final currentPosition = await _determinePosition();
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("laboratoire").get();

      for (var doc in querySnapshot.docs) {
        final laboratoire =
            laboratoryModel.fromFirestore(doc.data() as Map<String, dynamic>);
        print("Vérification du médecin : ${laboratoire.name}");
        if (laboratoire.location != null) {
          final distance = Geolocator.distanceBetween(
            currentPosition.latitude,
            currentPosition.longitude,
            laboratoire.location!.latitude,
            laboratoire.location!.longitude,
          );
          print("Distance jusqu'à ${laboratoire.name}: ${distance / 1000} km");

          if (distance / 1000 <= 10) {
            newList.add(laboratoire);
          }
        }
      }

      newList.sort((a, b) {
        return Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          a.location!.latitude,
          a.location!.longitude,
        ).compareTo(Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          b.location!.latitude,
          b.location!.longitude,
        ));
      });

      laboratoryModelList = newList.take(newList.length).toList();
      print(
          "laboratoires les plus proches trouvés: ${laboratoryModelList.length}");
      notifyListeners();
    } catch (e) {
      print(
          "Erreur lors de la recherche des laboratoires les plus proches: $e");
    }
  }

  Future<void> initializeUserPosition() async {
    try {
      userPosition = await _determinePosition();
    } catch (e) {
      print(
          'Erreur lors de la récupération de la position de l\'utilisateur: $e');
    }
  }

 List<laboratoryModel> searchlaboratoire({
  required String laboratoireName,
  required List<String> categories,
  required List<String> workDays,
  required LatLng selectedLocation,
  TimeOfDay? startTime,
  TimeOfDay? endTime,
}) {
  try {
    print('Début de la recherche de laboratoires');

    // Filtrer les laboratoires en fonction du nom
    List<laboratoryModel> results = laboratoryModelList.where((laboratoire) {
      // Vérifier si le nom du laboratoire contient la chaîne de recherche (insensible à la casse)
      return laboratoire.name.toLowerCase().contains(laboratoireName.toLowerCase());
    }).toList();

    // Filtrer les laboratoires en fonction des catégories sélectionnées
    if (categories.isNotEmpty) {
      results = results.where((laboratoire) {
        print('Catégories sélectionnées: $categories');
        print('Catégories du laboratoire ${laboratoire.name}: ${laboratoire.category}');
        // Vérifier si toutes les catégories spécifiées sont présentes dans les catégories du laboratoire
        return categories.every((category) => laboratoire.category.contains(category));
      }).toList();
    }

    // Filtrer les laboratoires en fonction des jours de travail
    if (workDays.isNotEmpty) {
      results = results.where((laboratoire) {
        return workDays.any((workDay) => laboratoire.workDays.contains(workDay));
      }).toList();
    }

    // Filtrer les laboratoires en fonction de la localisation sélectionnée
    results = results.where((laboratoire) {
      if (laboratoire.location != null) {
        double distance = Geolocator.distanceBetween(
          selectedLocation.latitude,
          selectedLocation.longitude,
          laboratoire.location!.latitude,
          laboratoire.location!.longitude,
        );
        return distance / 1000 <= 10; // Filtre les laboratoires situés dans un rayon de 10 km
      } else {
        return false;
      }
    }).toList();

    // Filtrer les laboratoires en fonction de l'heure de début et de fin
    if (startTime != null && endTime != null) {
      results = results.where((laboratoire) {
        // Analyser les chaînes d'heure de début et de fin en objets TimeOfDay
        try {
          TimeOfDay laboratoireStartTime = TimeOfDay(
            hour: int.parse(laboratoire.startTime.split(":")[0]),
            minute: int.parse(laboratoire.startTime.split(":")[1]),
          );
          TimeOfDay laboratoireEndTime = TimeOfDay(
            hour: int.parse(laboratoire.endTime.split(":")[0]),
            minute: int.parse(laboratoire.endTime.split(":")[1]),
          );

          // Comparer l'heure analysée avec l'heure de début et de fin sélectionnée
          return laboratoireStartTime.hour <= endTime.hour &&
              laboratoireEndTime.hour >= startTime.hour;
        } catch (e) {
          print("Erreur lors de l'analyse de l'heure du laboratoire: $e");
          return false;
        }
      }).toList();
    }

    print('Fin de la recherche de laboratoires');

    return results;
  } catch (e) {
    print('Erreur lors de la recherche de laboratoires: $e');
    return [];
  }
}

  Future<void> updateProfile(String newName, String newLocation,
      String newCategory, String newWorkDays) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String currentUserUid = user.uid;

        // Utiliser currentUserUid pour récupérer et mettre à jour le profil du laboratoire
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection("laboratoire")
            .doc(currentUserUid)
            .get();
        if (snapshot.exists) {
          await snapshot.reference.update({
            'name': newName,
            'location': newLocation,
            'category': newCategory,
            'workDays': newWorkDays,
          });
          notifyListeners();
        } else {
          print('Laboratory profile not found');
        }
      } else {
        print('No user is currently signed in');
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
  }
}

Future<Position> _determinePosition() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print('Services de localisation activés: $serviceEnabled');
    if (!serviceEnabled) {
      throw Exception('Les services de localisation sont désactivés.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    print('Permission de localisation actuelle: $permission');
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print('Demande de permission de localisation: $permission');
      if (permission == LocationPermission.denied) {
        throw Exception('Les permissions de localisation sont refusées');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Les permissions de localisation sont refusées de manière permanente');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print('Position actuelle: $position');
    return position;
  } catch (e) {
    print(
        'Erreur lors de la récupération de la position de l\'utilisateur: $e');
    rethrow;
  }
}
