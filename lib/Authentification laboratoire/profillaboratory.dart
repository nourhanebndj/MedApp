import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mediloc/Authentification%20laboratoire/Editprofillaboratorypage.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/main.dart';
import 'package:mediloc/model/category_laboratory.dart';

class Profillaboratory extends StatefulWidget {
  final String selectedLanguage;
  final List<CategorylaboratoryModel> categorylaboratoryModelList;
  final List<String> selectedCategories;
  final String selectedCategory;
  String name;
  final String laboratoryId;
  String email;
  String phone;
  List<String> workDays;
  String startTime;
  String endTime;
  final GeoPoint location;

  Profillaboratory({
    Key? key,
    required this.selectedLanguage,
    required this.name,
    required this.laboratoryId,
    required this.email,
    required this.phone,
    required List<CategorylaboratoryModel> categorylaboratoryModelList,
    required this.selectedCategories,
    required this.selectedCategory,
    required this.workDays,
    required this.startTime,
    required this.endTime,
    required this.location,
  })  : categorylaboratoryModelList = categorylaboratoryModelList,
        super(key: key);

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<Profillaboratory> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late Future<DocumentSnapshot<Map<String, dynamic>>> _profileDataFuture;
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _profileDataFuture = _fetchProfileData();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchProfileData() async {
    return FirebaseFirestore.instance
        .collection('laboratoire')
        .doc(widget.laboratoryId)
        .get();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _profileDataFuture = _fetchProfileData();
    });
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
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body:Directionality(
        textDirection:
            widget.selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('lib/assets/images/laboratorien.png'),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
                            Row(
                              children: [
                                Expanded(
                                  child: itemProfile(
                                    S.of(context).Name,
                                    snapshot.data!['name'],
                                    CupertinoIcons.person,
                                  ),
                                ),
                                Expanded(
                                  child: itemProfile(
                                    S.of(context).phone,
                                    snapshot.data!['phone'],
                                    CupertinoIcons.phone,
                                  ),
                                ),
                              ],
                            ),
                            itemProfile(
                              S.of(context).Email,
                              snapshot.data!['email'],
                              CupertinoIcons.mail,
                            ),
                            itemProfile(
                              S.of(context).category,
                              snapshot.data!['category'],
                              CupertinoIcons.tag,
                            ),
                            itemProfile(
                              S.of(context).work_days,
                              snapshot.data!['workDays'].join(', '),
                              CupertinoIcons.calendar,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: itemProfile(
                                    S.of(context).starttime,
                                    snapshot.data!['startTime'],
                                    Icons.watch_later_outlined,
                                  ),
                                ),
                                Expanded(
                                  child: itemProfile(
                                    S.of(context).endtime,
                                    snapshot.data!['endTime'],
                                    Icons.watch_later_outlined,
                                  ),
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
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            laboratory: widget,
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(100, 235, 182, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).EditProfil,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ],
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
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                Text(subtitle,
                    style:
                        const TextStyle(fontSize: 16, color: Colors.black54)),
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
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MyApp()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la déconnexion : $e'),
      ));
    }
  }
}
