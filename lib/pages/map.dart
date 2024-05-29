import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/laboratoire/laboratorydetailpage.dart';
import 'package:mediloc/medecin/medecindetail.dart';
import 'package:mediloc/model/laboratory_model.dart';
import 'package:mediloc/model/medecin_model.dart';
import 'package:mediloc/model/pharmacie_model.dart';
import 'package:mediloc/pharmacie/pharmaciedetailspage.dart';
import 'package:mediloc/provider/laboratoire_provider.dart';
import 'package:mediloc/provider/myprovider_doctor.dart';
import 'package:mediloc/provider/myproviderpharmacie.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  final String selectedLanguage;
  const MapPage({Key? key, required this.selectedLanguage}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  List<Marker> markers = [];
  DoctorProvider doctorProvider = DoctorProvider();
  PharmacieProvider pharmacieProvider = PharmacieProvider();
  LaboratoireProvider laboratoireProvider = LaboratoireProvider();
  Position? userPosition;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialisez la position de l'utilisateur
    _getUserLocation();
    // Chargez les données des médecins et des pharmacies
    _loadDoctorsAndPharmaciesAndlaboratory();
  }

  // Récupérer la position de l'utilisateur
  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userPosition = position;
    });
  }

  // Charger les médecins et les pharmacies et les laboratoires
  void _loadDoctorsAndPharmaciesAndlaboratory() async {
    await laboratoireProvider.getlaboratory();
    await doctorProvider.getDoctors();
    await pharmacieProvider.getPharmacies();
    _addMarkers();
  }
  // Ajouter des marqueurs pour les médecins et les pharmacies et les laboratoires
  void _addMarkers() {
    setState(() {
      markers.addAll(
        doctorProvider.doctorModelList.map((doctor) {
          return Marker(
            markerId: MarkerId(doctor.name),
            position:
                LatLng(doctor.location!.latitude, doctor.location!.longitude),
            onTap: () => _showDoctorDetails(context, doctor),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          );
        }),
      );
      markers.addAll(
        pharmacieProvider.pharmacieModelList.map((pharmacie) {
          return Marker(
            markerId: MarkerId(pharmacie.name),
            position: LatLng(
                pharmacie.location!.latitude, pharmacie.location!.longitude),
            onTap: () => _showPharmacieDetails(context, pharmacie),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          );
        }),
      );
      markers.addAll(
     laboratoireProvider.laboratoryModelList.map((laboratoire) {
          return Marker(
            markerId: MarkerId(laboratoire.name),
            position: LatLng(
                laboratoire.location!.latitude, laboratoire.location!.longitude),
            onTap: () => _showLaboratoireDetails(context, laboratoire),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),
          );
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: userPosition != null
              ? CameraPosition(
                  target:
                      LatLng(userPosition!.latitude, userPosition!.longitude),
                  zoom: 8,
                )
              : const CameraPosition(
                  target: LatLng(36.9, 7.766667),
                  zoom: 6,
                ),
          markers: Set<Marker>.of(markers),
        ),
        Positioned(
          top: 50.0,
          left: 20.0,
          right: 20.0,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6.0,
                    offset:const  Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search), 
                  const SizedBox(
                      width:
                          8), 
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: _searchLocation,
                      decoration: InputDecoration(
                        hintText: S.of(context).search_doctor_or_pharmacist_laboratory,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _searchLocation(String query) {
    setState(() {
      markers.clear();
    });

    // Filtrer les médecins dont le nom correspond à la recherche
    List<DoctorModel> filteredDoctors =
        doctorProvider.doctorModelList.where((doctor) {
      return doctor.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    // Filtrer les pharmacies dont le nom correspond à la recherche
    List<PharmacieModel> filteredPharmacies =
        pharmacieProvider.pharmacieModelList.where((pharmacie) {
      return pharmacie.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
 // Filtrer les laboratoires dont le nom correspond à la recherche
    List<laboratoryModel> filteredlaboratory =
       laboratoireProvider.laboratoryModelList.where((laboratoire) {
      return laboratoire.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    // Ajouter les nouveaux marqueurs filtrés
    setState(() {
      markers.addAll(
        filteredDoctors.map((doctor) {
          return Marker(
            markerId: MarkerId(doctor.name),
            position:
                LatLng(doctor.location!.latitude, doctor.location!.longitude),
            onTap: () => _showDoctorDetails(context, doctor),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          );
        }),
      );
      markers.addAll(
        filteredPharmacies.map((pharmacie) {
          return Marker(
            markerId: MarkerId(pharmacie.name),
            position: LatLng(
                pharmacie.location!.latitude, pharmacie.location!.longitude),
            onTap: () => _showPharmacieDetails(context, pharmacie),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          );
        }),
      );
      markers.addAll(
        filteredlaboratory.map((laboratoire) {
          return Marker(
            markerId: MarkerId(laboratoire.name),
            position: LatLng(
                laboratoire.location!.latitude, laboratoire.location!.longitude),
            onTap: () => _showLaboratoireDetails(context, laboratoire),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),
          );
        }),
      );
    });
  }

  void _showDoctorDetails(BuildContext context, DoctorModel doctor) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: SizedBox(
            height: 160,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedecinDetailsPage(
                      medecin: doctor.toMap(),
                      selectedLanguage: widget.selectedLanguage,
                    ),
                  ),
                );
              },
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(8),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('lib/assets/images/MediApp.png'),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4), // Réduire les marges
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${S.of(context).Dr} ${doctor.name}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.category,
                                    size: 16,
                                    color: Color.fromRGBO(100, 235, 182, 1),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      "${S.of(context).Specialty}: ${doctor.category.join(', ')}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                    color: Color.fromRGBO(100, 235, 182, 1),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      "${S.of(context).Days}: ${doctor.workDays.join(', ')}",
                                      style: const TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    size: 16,
                                    color: Color.fromRGBO(100, 235, 182, 1),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${S.of(context).Hours}: ${doctor.startTime} - ${doctor.endTime}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPharmacieDetails(BuildContext context, PharmacieModel pharmacie) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: SizedBox(
            height: 160,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PharmacieDetailsPage(
                      pharmacie: pharmacie,
                      selectedLanguage: widget.selectedLanguage,
                    ),
                  ),
                );
              },
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(8),
                child: Card(
                  color: Colors.white,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Image à gauche dans un cercle
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('lib/assets/images/MediApp.png'),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4), // Réduire les marges
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Aligner le texte à gauche
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Centrer verticalement le texte
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.local_pharmacy,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    " ${pharmacie.name}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone,
                                    size: 16,
                                    color: Color.fromRGBO(100, 235, 182, 1),
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Text(
                                      " ${pharmacie.phone}",
                                      style: const TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                    color: Color.fromRGBO(100, 235, 182, 1),
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Text(
                                      " ${pharmacie.workDays.join(', ')}",
                                      style: const TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    size: 16,
                                    color: Color.fromRGBO(100, 235, 182, 1),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    " ${pharmacie.startTime} - ${pharmacie.endTime}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  void _showLaboratoireDetails(BuildContext context, laboratoryModel laboratoire) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: SizedBox(
          height: 160,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>laboratoryDetailsPage(
                    laboratory: laboratoire.toMap(),
                    selectedLanguage: widget.selectedLanguage,
                  ),
                ),
              );
            },
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(8),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage('lib/assets/images/MediApp.png'),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 4), 
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.biotech,
                                  size: 30,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${S.of(context).Laboratory} ${laboratoire.name}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.category,
                                  size: 16,
                                  color: Color.fromRGBO(100, 235, 182, 1),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    "${S.of(context).Specialty} ${laboratoire.category.join(', ')}",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 16,
                                  color: Color.fromRGBO(100, 235, 182, 1),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    "${S.of(context).Days}${laboratoire.workDays.join(', ')}",
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.schedule,
                                  size: 16,
                                  color: Color.fromRGBO(100, 235, 182, 1),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${S.of(context).Hours} ${laboratoire.startTime} - ${laboratoire.endTime}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}


}
