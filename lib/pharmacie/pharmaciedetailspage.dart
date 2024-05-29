import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/model/pharmacie_model.dart';
import 'package:mediloc/pharmacie/demande_medicament.dart';
import 'package:permission_handler/permission_handler.dart';

class PharmacieDetailsPage extends StatefulWidget {
  final PharmacieModel pharmacie;
    final String selectedLanguage;


  const PharmacieDetailsPage({Key? key, required this.pharmacie,required this.selectedLanguage}) : super(key: key);

  @override
  _PharmacieDetailsPageState createState() => _PharmacieDetailsPageState();
}

class _PharmacieDetailsPageState extends State<PharmacieDetailsPage> {
  late LatLng latLngLocation;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    requestLocationPermission();
  }

  Future<void> _initializeLocation() async {
    GeoPoint? location = widget.pharmacie.location;
    if (location != null) {
      setState(() {
        latLngLocation = LatLng(location.latitude, location.longitude);
      });
    } else {
      setState(() {
        latLngLocation = const LatLng(0, 0); // Utiliser une localisation par défaut ou gérer l'absence de localisation
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
    String name = widget.pharmacie.name;
    String email = widget.pharmacie.email;
    String phone = widget.pharmacie.phone;
    String startTime = widget.pharmacie.startTime;
    String endTime = widget.pharmacie.endTime;
    String workdays = widget.pharmacie.workDays.join(", ");
    String photoUrl = 'lib/assets/images/pharmacien.png';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:Directionality(
        textDirection: widget.selectedLanguage == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                },
                child: Container(
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
                        markerId: const MarkerId('PharmacistLocation'),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        S.of(context).About_the_Pharmacist,
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      leading: Image.asset(photoUrl, width: 80, height: 80),
                      title: Text(
                        name,
                        style: const TextStyle(
                          fontWeight:FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRichText(S.of(context).Email, email),
                          const SizedBox(height: 10),
                          _buildRichText(S.of(context).phone, phone),
                          const SizedBox(height: 10),
                          _buildRichText(S.of(context).work_days, workdays),
                          const SizedBox(height: 10),
                          _buildRichText(S.of(context).Available_From, startTime),
                          const SizedBox(height: 10),
                          _buildRichText(S.of(context).Available_Until, endTime),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                       Navigator.push( context, MaterialPageRoute(
                        builder: (context) =>MedicationRequestPage(pharmacie: widget.pharmacie,selectedLanguage:widget.selectedLanguage,)
                        ),
                    );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(100, 235, 182, 1),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                                  child:Text(S.of(context).Medication_Request,
                                  style: const TextStyle(
                                    color:Colors.white
                                    ),
                                  
                                  ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  RichText _buildRichText(String title, String value) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(text: title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
          TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 15)),
        ],
      ),
    );
  }
}
