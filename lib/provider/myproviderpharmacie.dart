import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mediloc/model/pharmacie_model.dart';

class PharmacieProvider with ChangeNotifier {
  List<PharmacieModel> pharmacieModelList = [];
  Position? userPosition;

  Future<void> getPharmacies() async {
    print("Début du chargement des pharmacies depuis Firestore");
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Pharmacie").get();
      pharmacieModelList = querySnapshot.docs.map((doc) => PharmacieModel.fromFirestore(doc)).toList();
      print("Pharmacies chargées avec succès: ${pharmacieModelList.length}");
      notifyListeners();
    } catch (e) {
      print("Erreur lors du chargement des pharmacies: $e");
    }
  }

  // Méthode pour obtenir les pharmacies les plus proches dans un rayon de 20 km
  Future<void> getNearestPharmacies() async {
    print("Début de la recherche des pharmacies les plus proches");
    try {
      List<PharmacieModel> newList = [];
      final currentPosition = await _determinePosition();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Pharmacie").get();

      for (var doc in querySnapshot.docs) {
        final pharmacie = PharmacieModel.fromFirestore(doc);
        print("Vérification de la pharmacie : ${pharmacie.name}");
        if (pharmacie.location != null) {
          final distance = Geolocator.distanceBetween(
            currentPosition.latitude,
            currentPosition.longitude,
            pharmacie.location!.latitude,
            pharmacie.location!.longitude,
          );
          print("Distance jusqu'à ${pharmacie.name}: ${distance / 1000} km");

          if (distance / 1000 <= 10) {
            newList.add(pharmacie);
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

      pharmacieModelList = newList.take(newList.length).toList();
      print("Pharmacies les plus proches trouvées: ${pharmacieModelList.length}");
      notifyListeners();
    } catch (e) {
      print("Erreur lors de la recherche des pharmacies les plus proches: $e");
    }
  }

//Recuperer la position de l'utilisateur
  Future<void> initializeUserPosition() async {
    try {
      userPosition = await _determinePosition();
    } catch (e) {
      print(
          'Erreur lors de la récupération de la position de l\'utilisateur: $e');
    }
  }
//Methode de rechrcher les pharmaciens
  List<PharmacieModel> searchPharmacies({
    required String pharmacyName,
    required List<String> workDays,
    required LatLng selectedLocation,
      TimeOfDay? startTime,
      TimeOfDay? endTime,
  }) {
    try {
      print('Début de la recherche de pharmacies');

      // Filtrer les pharmacies en fonction du nom
      List<PharmacieModel> results = pharmacieModelList.where((pharmacie) {
        // Vérifier si le nom de la pharmacie contient la chaîne de recherche 
        return pharmacie.name.toLowerCase().contains(pharmacyName.toLowerCase());
      }).toList();

      // Filtrer les pharmacies en fonction des jours de travail
      if (workDays.isNotEmpty) {
        results = results.where((pharmacie) {
          // Vérifier si la pharmacie travaille au moins un des jours sélectionnés
          return workDays.any((workDay) => pharmacie.workDays.contains(workDay));
        }).toList();
      }

      // Filtrer les pharmacies en fonction de la localisation sélectionnée
      results = results.where((pharmacie) {
        double distance = Geolocator.distanceBetween(
          selectedLocation.latitude,
          selectedLocation.longitude,
          pharmacie.location!.latitude,
          pharmacie.location!.longitude,
        );

        // Vérifier si la distance est inférieure ou égale à 10 km
        return distance / 1000 <= 10;
      }).toList();

// Filtrer les médecins en fonction de l'heure de début et de fin
if (startTime != null && endTime != null) {
  results = results.where((pharmacie) {
    // Analyse les chaînes d'heure de début et de fin dans des objets TimeOfDay
    try {
      TimeOfDay pharmacieStartTime = TimeOfDay(
        hour: int.parse(pharmacie.startTime.split(":")[0]),
        minute: int.parse(pharmacie.startTime.split(":")[1])
      );
      TimeOfDay pharmacieEndTime = TimeOfDay(
        hour: int.parse(pharmacie.endTime.split(":")[0]),
        minute: int.parse(pharmacie.endTime.split(":")[1])
      );

      // Comparez l'heure analysée avec l'heure de début et de fin sélectionnée
      return pharmacieStartTime.hour <= endTime.hour &&
             pharmacieEndTime.hour >= startTime.hour;
    } catch (e) {
      print("Erreur lors de l'analyse de l'heure du médecin: $e");
      return false;
    }
  }).toList();
}


      print('Fin de la recherche de pharmacies');

      return results;
    } catch (e) {
      print('Erreur lors de la recherche des pharmacies: $e');
      return [];
    }
  }

  // Méthode  pour déterminer la position actuelle de l'utilisateur
  Future<Position> _determinePosition() async {
    print("Tentative de détermination de la position de l'utilisateur");
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Les services de localisation sont désactivés.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Les permissions de localisation sont refusées');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Les permissions de localisation sont refusées de manière permanente');
      } 

      Position position = await Geolocator.getCurrentPosition();
      print("Position de l'utilisateur déterminée : ${position.latitude}, ${position.longitude}");
      return position;
    } catch (e) {
      print("Erreur lors de la détermination de la position: $e");
      rethrow; 
    }
  }
}
