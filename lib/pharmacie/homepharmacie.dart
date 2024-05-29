import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/SearchPages/search_pharmacie.dart';
import 'package:mediloc/pharmacie/AllPharmacie.dart' as AllPharmacie;
import 'package:mediloc/pharmacie/pharmaciedetailspage.dart';
import 'package:mediloc/provider/demande_medicament_provider.dart';
import 'package:mediloc/provider/myproviderpharmacie.dart';
import 'package:mediloc/provider/prendre_rendez_vous_provider.dart';
import 'package:provider/provider.dart';

class HomePharmacie extends StatefulWidget {
  final String selectedLanguage;
  const HomePharmacie({Key? key, required this.selectedLanguage}) : super(key: key);

  @override
  _HomePharmacieState createState() => _HomePharmacieState();
}

class _HomePharmacieState extends State<HomePharmacie> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pharmacieProvider =
          Provider.of<PharmacieProvider>(context, listen: false);
      pharmacieProvider.getNearestPharmacies();
    });
  }

  Future<void> _refreshData() async {
    final pharmacieProvider =
        Provider.of<PharmacieProvider>(context, listen: false);
    await pharmacieProvider.getNearestPharmacies();
    await Provider.of<AppointmentsProvider>(context, listen: false).getNotifications();
  await Provider.of<DemandeMedicamentProvider>(context, listen: false).getNotifications();
  }

  @override
  Widget build(BuildContext context) {
        final userId = FirebaseAuth.instance.currentUser?.uid;

    final pharmacieProvider = Provider.of<PharmacieProvider>(context);
    return Directionality(
      textDirection: widget.selectedLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
          child: userId == null
            ? Center(child: Text(S.of(context).No_user_logged_in))
            : FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('malade')
                    .doc(userId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.data() == null) {
                    return const Center(child: Text('Document does not exist'));
                  }

                  var userDoc = snapshot.data!.data() as Map<String, dynamic>;
                  var username = userDoc['username'] ?? 'No username';
                  var latitude = userDoc['latitude'] ?? 'No latitude';
                  var longitude = userDoc['longitude'] ?? 'No longitude';
      return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: false,
              elevation: 0,
              backgroundColor: Colors.transparent,
              toolbarHeight: 80,
              title: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                            children: [
                               const Icon(Icons.person_rounded, color: Color.fromARGB(255, 0, 0, 0)), 
                              Text(
                                '${S.of(context).Hello} ',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 122, 122, 122),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:18,
                                  color: Color.fromARGB(255, 57, 57, 57),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5), 
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, color: Color.fromARGB(255, 255, 9, 9)), 
                                      const SizedBox(width: 5),
                                      Text(
                                        '$latitude, $longitude',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                        
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Stack(
                      children: [
                        const Icon(Icons.notifications),
                        Positioned(
                          right: 0,
                          top: 0, // Positionnez le CircleAvatar en haut
                          child: Consumer<AppointmentsProvider>(
                            builder: (context, appointmentProvider, _) {
                              int appointmentNotificationCount =
                                  appointmentProvider.getNotifications().length;
                              int demandeMedicamentNotificationCount =
                                  Provider.of<DemandeMedicamentProvider>(context, listen: false)
                                      .getNotifications()
                                      .length;
                              int totalNotifications = appointmentNotificationCount +
                                  demandeMedicamentNotificationCount;
                              return totalNotifications > 0
                                  ? CircleAvatar(
                                      radius: 7,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        '$totalNotifications',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink();
                            },
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      // Ajoutez ici le code pour afficher la boîte de dialogue de notifications
                      showNotificationDialog(context);
                    },
                  ),
                ],
              ),
              leading: const Padding(
                padding: EdgeInsets.only(top: 0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => searchPharmaciePage(selectedLanguage:widget.selectedLanguage,)),
                    );
                  },
                  child:  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Icon(Icons.search),
                      ),
                      Expanded(
                        child: Text(
                          S.of(context).Search_pharmacist,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                     const  Icon(
                        Icons.filter_list,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ),
           SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                // création de slider
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 150.0,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    aspectRatio: 1.85 / 1,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    pauseAutoPlayOnTouch: true,
                    viewportFraction: 0.8,
                    onPageChanged: (index, reason) {},
                  ),
                  items: imageAssetPaths.map((assetPath) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: AssetImage(assetPath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                  
                ),

              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      S.of(context).Top_pharmacist,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllPharmacie.AllPharmaciePage(selectedLanguage:widget.selectedLanguage,),
                          ),
                        );
                      },
                      child: Padding(
                        padding:const  EdgeInsets.only(top: 5.0),
                        child: Text(
                          S.of(context).View_All,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
           SliverToBoxAdapter(
  child: Visibility(
    visible: pharmacieProvider.pharmacieModelList.isNotEmpty,
    replacement: Center(
      child: Text(
        S.of(context).No_pharmacist_found_in_your_zone,
        style: const TextStyle(fontSize: 16,color:Colors.red),
      ),
      
    ),
    child: SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: min(pharmacieProvider.pharmacieModelList.length, 5),
        itemBuilder: (BuildContext context, int index) {
          final pharmacie = pharmacieProvider.pharmacieModelList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PharmacieDetailsPage(pharmacie: pharmacie,selectedLanguage:widget.selectedLanguage,),
                ),
              );
            },
            child: Container(
              width: 310,
              padding: const EdgeInsets.all(4),
              child: Card(
                color: Colors.white,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      backgroundColor:Colors.transparent,
                      radius: 40, 
                      backgroundImage: AssetImage('lib/assets/images/MediApp.png'),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4), // Réduire les marges
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Aligner le texte à gauche
                          mainAxisAlignment: MainAxisAlignment.center, // Centrer verticalement le texte
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
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          );
        },
      ),
    ),
  ),
),

          ],
        ),
      );
                    }
                    )
    );
  }
}

void showNotificationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(S.of(context).notificationsTitle),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).appointmentNotifications,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Consumer<AppointmentsProvider>(
                builder: (context, appointmentsProvider, _) {
                  List<CustomNotification> appointmentNotifications =
                      appointmentsProvider.getNotifications();
                  if (appointmentNotifications.isEmpty) {
                    return Text(S.of(context).noNotifications);
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: appointmentNotifications.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: InkWell(
                            onTap: () {
                              appointmentsProvider
                                  .markNotificationAsRead(index);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'lib/assets/images/MediApp.png',
                                    width: 60,
                                    height: 60,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          appointmentNotifications[index]
                                              .message,
                                          style:const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          appointmentNotifications[index]
                                              .timestamp
                                              .toString(),
                                          style:const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                S.of(context).requestNotifications,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Consumer<DemandeMedicamentProvider>(
                builder: (context, demandeMedicamentProvider, _) {
                  List<NotificationCustom> demandeMedicamentNotifications =
                      demandeMedicamentProvider.getNotifications();
                  if (demandeMedicamentNotifications.isEmpty) {
                    return Text(S.of(context).noNotifications);
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: demandeMedicamentNotifications.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: InkWell(
                            onTap: () {
                              demandeMedicamentProvider
                                  .markNotificationAsRead(index);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'lib/assets/images/MediApp.png',
                                    width: 60,
                                    height: 60,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          demandeMedicamentNotifications[index]
                                              .message,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          demandeMedicamentNotifications[index]
                                              .timestamp
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).closeButton),
          ),
        ],
      );
    },
  );
}

List<String> imageAssetPaths = [
  'lib/assets/images/pharmacie_notice2.png',
  'lib/assets/images/pharmacie_notice1.png',
  'lib/assets/images/pharmacie_notice.png',
];

