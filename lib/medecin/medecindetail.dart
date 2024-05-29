import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/medecin/prendrerendezvous.dart';
import 'package:mediloc/model/medecin_model.dart';
import 'package:permission_handler/permission_handler.dart';

class MedecinDetailsPage extends StatefulWidget {
  final Map<String, dynamic> medecin;
    final String selectedLanguage;


  const MedecinDetailsPage({Key? key, required this.medecin,required this.selectedLanguage}) : super(key: key);

  @override
  _MedecinDetailsPageState createState() => _MedecinDetailsPageState();
}

class _MedecinDetailsPageState extends State<MedecinDetailsPage> {
  late LatLng latLngLocation;
  String categoriesDisplay = '';

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _initializeCategories();
    requestLocationPermission();
    print('Catégorie récupérée: ${widget.medecin['category']}');
  }

  void _initializeCategories() {
    var category = widget.medecin['category'];
    if (category is List) {
      categoriesDisplay = category.join(', ');
    } else if (category is String) {
      categoriesDisplay = category;
    } else {
      categoriesDisplay = 'Category not provided';
    }
  }

  Future<void> _initializeLocation() async {
    if (widget.medecin['location'] != null &&
        widget.medecin['location'] is GeoPoint) {
      GeoPoint location = widget.medecin['location'] as GeoPoint;
      setState(() {
        latLngLocation = LatLng(location.latitude, location.longitude);
      });
      //test pour voir si la location recuperee
      print(
          "Location récupérée: Latitude ${location.latitude}, Longitude ${location.longitude}");
    } else {
      //test pour voir si la location n'est pas recuperee
      print(
          "Location est null ou n'est pas un GeoPoint. Utilisation de la localisation par défaut.");
      setState(() {
        latLngLocation = const LatLng(0, 0);
      });
    }
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.medecin['name'] ?? 'Unknown Doctor';
    String email = widget.medecin['email'] ?? 'No email provided';
    String phone = widget.medecin['phone'] ?? 'No phone provided';
    String startTime = widget.medecin['startTime'] ?? 'Not Available';
    String endTime = widget.medecin['endTime'] ?? 'Not Available';
    String workdays = widget.medecin['workDays'] is List
        ? (widget.medecin['workDays'] as List).join(", ")
        : 'Not Available';
    String photoUrl =
        widget.medecin['photoUrl'] ?? 'lib/assets/images/medecin.png';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:Directionality(
        textDirection: widget.selectedLanguage == 'ar'? TextDirection.rtl: TextDirection.ltr,
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {  
                },
                child: SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: latLngLocation,
                      zoom: 12,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('medecinLocation'),
                        position: latLngLocation,
                      ),
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding:const  EdgeInsets.all(8.0),
                      child: Text(
                        S.of(context).aboutDoctor,
                        style:
                  const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      leading: Image.asset(photoUrl, width: 80, height: 80),
                      title: Text(
                        "${S.of(context).Dr} $name",

                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        ' $categoriesDisplay',
                        style: const TextStyle(
                            fontSize: 18, color: Color.fromRGBO(34, 130, 190, 1)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                 TextSpan(
                                    text:'${S.of(context).Email} : ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black)),
                                TextSpan(
                                    text: email,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 15)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text:'${S.of(context).phone} : ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black)),
                                TextSpan(
                                    text: phone,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 15)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: '${S.of(context).work_days} : ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black)),
                                TextSpan(
                                    text: workdays,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 15)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                               TextSpan(
                                    text:'${S.of(context).Available_From} : ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black)),
                                TextSpan(
                                    text: startTime,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 15)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                 TextSpan(
                                    text:'${S.of(context).Available_Until} : ',
                                    style:const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black)),
                                TextSpan(
                                    text: endTime,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 15)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                        onPressed: () {
                      DoctorModel selectedDoctor= DoctorModel.fromFirestore(widget.medecin);
           print("Selected Doctor ID: ${selectedDoctor.doctorId}");
            Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AppointmentsPage(doctor: selectedDoctor,
          doctorId: selectedDoctor.doctorId,
          selectedLanguage:widget.selectedLanguage,
          ),
        ),
            );
          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(100, 235, 182, 1),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: Text(S.of(context).bookAppointment,
                      style:const TextStyle(
                        color:Colors.white
                        ),
                        ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
