import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mediloc/authentification%20pharmacie/editprofilpharmacie.dart';
import 'package:mediloc/authentification%20pharmacie/request_medicent.dart';
import 'package:mediloc/authentification%20pharmacie/welcomepharmacie.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilScreenPharmacie extends StatefulWidget {
  final String selectedLanguage;
  final String name;
  final String email;
  final String phone;
  final List<String> workDays;
  final String pharmacieId;
  final String startTime;
  final String endTime;
  final GeoPoint location;

  const ProfilScreenPharmacie({
    Key? key,
    required this.selectedLanguage,
    required this.name,
    required this.email,
    required this.phone,
    required this.workDays,
    required this.pharmacieId,
    required this.startTime,
    required this.endTime,
    required this.location,
  }) : super(key: key);

  @override
  _ProfilScreenPharmacieState createState() => _ProfilScreenPharmacieState();
}

class _ProfilScreenPharmacieState extends State<ProfilScreenPharmacie> {
  late GoogleMapController mapController;
  late Future<DocumentSnapshot<Map<String, dynamic>>> _profileDataFuture;

  @override
  void initState() {
    super.initState();
    _profileDataFuture = _fetchProfileData();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchProfileData() async {
    return FirebaseFirestore.instance
        .collection('Pharmacie')
        .doc(widget.pharmacieId)
        .get();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _profileDataFuture = _fetchProfileData();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final LatLng latLng =
        LatLng(widget.location.latitude, widget.location.longitude);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(S.of(context).Profile,
            style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Color.fromARGB(255, 223, 0, 0)),
            onPressed: () => confirmDeleteProfile(),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: Directionality(
        textDirection:
            widget.selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: _profileDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No data available'));
                  } else {
                    return Column(
                      children: [
                        const CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage('lib/assets/images/pharmacien.jpg'),
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: itemProfile(S.of(context).Name, snapshot.data!['name'], CupertinoIcons.person),
                            ),
                            Expanded(
                              child: itemProfile(S.of(context).phone, snapshot.data!['phone'], CupertinoIcons.phone),
                            ),
                          ],
                        ),
                        itemProfile(S.of(context).Email, snapshot.data!['email'], CupertinoIcons.mail),
                        itemProfile(S.of(context).work_days, widget.workDays.join(', '), CupertinoIcons.calendar),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: itemProfile(S.of(context).starttime, widget.startTime, Icons.watch_later_outlined),
                            ),
                            Expanded(
                              child: itemProfile(S.of(context).endtime, widget.endTime, Icons.watch_later_outlined),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 200,
                          child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: latLng,
                              zoom: 15.0,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('pharmacyLocation'),
                                position: latLng,
                              ),
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DemandeMedicamentList(pharmacieId: widget.pharmacieId,selectedLanguage:widget.selectedLanguage,),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(100, 235, 182, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).Consult_Your_Requests,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfilepharmacieScreen(pharmacie:widget,selectedLanguage:widget.selectedLanguage,),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(100, 235, 182, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).edit_profil,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 5),
            color: Color.fromARGB(255, 204, 203, 203),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(iconData, color: const Color.fromRGBO(100, 235, 182, 1)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text(subtitle, style: const TextStyle(fontSize: 16, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyApp()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error logging out: $e'),
      ));
    }
  }
   void confirmDeleteProfile() async {
  bool confirm = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(S.of(context).confirmDeletion),
        content: Text(S.of(context).confirmDeletionMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              S.of(context).delete,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  ) ??
  false;

  if (confirm) {
    deleteProfile();
  }
}


  void deleteProfile() async {
  try {
    await FirebaseFirestore.instance
        .collection('Pharmacie')
        .doc(widget.pharmacieId)
        .delete();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomePharmaciePage(selectedLanguage: widget.selectedLanguage)),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).deleteSuccess)),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${S.of(context).deleteError}: $e')),
    );
  }
}

}
