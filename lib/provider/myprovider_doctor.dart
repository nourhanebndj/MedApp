import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mediloc/model/medecin_model.dart'; 

class DoctorProvider with ChangeNotifier {
  List<DoctorModel> doctorModelList = [];
  Position? userPosition;

 Future<void> getDoctors() async {
  FirebaseFirestore.instance.collection("medecin").snapshots().listen((querySnapshot) {
    doctorModelList = querySnapshot.docs
        .map((doc) => DoctorModel.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }, onError: (error) {
    print("Erreur lors du chargement des médecins: $error");
  });
}


 Future<void> getNearestDoctors() async {
    print("Début de la recherche des médecins les plus proches");
    try {
      List<DoctorModel> newList = [];
      final currentPosition = await _determinePosition();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("medecin").get();

      for (var doc in querySnapshot.docs) {
        final medecin = DoctorModel.fromFirestore(doc.data() as Map<String, dynamic>);
        print("Vérification du médecin : ${medecin.name}");
        if (medecin.location != null) {
          final distance = Geolocator.distanceBetween(
            currentPosition.latitude,
            currentPosition.longitude,
            medecin.location!.latitude,
            medecin.location!.longitude,
          );
          print("Distance jusqu'à ${medecin.name}: ${distance / 1000} km");

          if (distance / 1000 <= 10) {
            newList.add(medecin);
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

      doctorModelList = newList.take(newList.length).toList();
      print("Médecins les plus proches trouvés: ${doctorModelList.length}");
      notifyListeners();
    } catch (e) {
      print("Erreur lors de la recherche des médecins les plus proches: $e");
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

 List<DoctorModel> searchDoctors({
  required String doctorName,
  required List<String> categories,
  required List<String> workDays,
  required LatLng selectedLocation,
  TimeOfDay? startTime,
  TimeOfDay? endTime,
}) {
  try {
    print('Début de la recherche de médecins');

    // Filtrer les médecins en fonction du nom
    List<DoctorModel> results = doctorModelList.where((doctor) {
      // Vérifier si le nom du médecin contient la chaîne de recherche (insensible à la casse)
      return doctor.name.toLowerCase().contains(doctorName.toLowerCase());
    }).toList();

    // Filtrer les médecins en fonction des catégories
    if (categories.isNotEmpty) {
      results = results.where((doctor) {
        return categories.any((category) => doctor.category.contains(category));
      }).toList();
    }

    // Filtrer les médecins en fonction des jours de travail
    if (workDays.isNotEmpty) {
      results = results.where((doctor) {
        return workDays.any((workDay) => doctor.workDays.contains(workDay));
      }).toList();
    }

    // Filtrer les médecins en fonction de la localisation sélectionnée
    results = results.where((doctor) {
      if (doctor.location != null) {
        double distance = Geolocator.distanceBetween(
          selectedLocation.latitude,
          selectedLocation.longitude,
          doctor.location!.latitude,
          doctor.location!.longitude,
        );
        return distance / 1000 <= 10;
      } else {
        return false;
      }
    }).toList();

    // Filtrer les médecins en fonction de l'heure de début et de fin
    if (startTime != null && endTime != null) {
      results = results.where((doctor) {
        // Parse the start and end time strings into TimeOfDay objects
        try {
          TimeOfDay doctorStartTime = TimeOfDay(
            hour: int.parse(doctor.startTime.split(":")[0]),
            minute: int.parse(doctor.startTime.split(":")[1])
          );
          TimeOfDay doctorEndTime = TimeOfDay(
            hour: int.parse(doctor.endTime.split(":")[0]),
            minute: int.parse(doctor.endTime.split(":")[1])
          );

          // Compare the parsed time with the selected start and end time
          return doctorStartTime.hour <= endTime.hour &&
                 doctorEndTime.hour >= startTime.hour;
        } catch (e) {
          print("Erreur lors de l'analyse de l'heure du médecin: $e");
          return false;
        }
      }).toList();
    }

    print('Fin de la recherche de médecins');

    return results;
  } catch (e) {
    print('Erreur lors de la recherche des médecins: $e');
    return [];
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
      print('Erreur lors de la récupération de la position de l\'utilisateur: $e');
      rethrow;
    }
  }
}
