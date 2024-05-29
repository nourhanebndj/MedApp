import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/laboratoire/Homelaboratory.dart';
import 'package:mediloc/provider/demande_medicament_provider.dart';
import 'package:mediloc/pages/map.dart';
import 'package:mediloc/pages/AccountPage.dart';
import 'package:mediloc/provider/prendre_rendez_vous_provider.dart';
import 'package:mediloc/categorie/AllCategoriesPage.dart';
import 'package:mediloc/medecin/AllDoctors.dart';
import 'package:mediloc/model/category_model.dart';
import 'package:mediloc/categorie/categoryscreendetail.dart';
import 'package:mediloc/medecin/medecindetail.dart';
import 'package:mediloc/pharmacie/homepharmacie.dart';
import 'package:mediloc/provider/myprovider.dart';
import 'package:mediloc/provider/myprovider_doctor.dart';
import 'package:mediloc/SearchPages/search_medecin.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final String selectedLanguage;
  const Home({Key? key, required this.selectedLanguage}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  Map<String, dynamic>? selectedMedecinData;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Provider.of<DoctorProvider>(context, listen: false).getNearestDoctors();
    }
  }

  Future<void> _refreshData() async {
    await Provider.of<DoctorProvider>(context, listen: false)
        .initializeUserPosition();
    await Provider.of<DoctorProvider>(context, listen: false)
        .getNearestDoctors();
    await Provider.of<Myprovider>(context, listen: false).getCategory();
    await Provider.of<AppointmentsProvider>(context, listen: false)
        .getNotifications();
    await Provider.of<DemandeMedicamentProvider>(context, listen: false)
        .getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeTab(selectedLanguage: widget.selectedLanguage),
            HomePharmacie(selectedLanguage: widget.selectedLanguage),
            Homelaboratory(selectedLanguage: widget.selectedLanguage),
            MapPage(selectedLanguage: widget.selectedLanguage),
            AccountPage(selectedLanguage: widget.selectedLanguage),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: S.of(context).Home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_pharmacy_outlined),
            label: S.of(context).Pharmacist,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.biotech),
            label: S.of(context).Laboratory,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map_sharp),
            label: S.of(context).Map,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: S.of(context).Profile,
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: const Color.fromRGBO(100, 235, 182, 1),
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  final String selectedLanguage;
  const HomeTab({Key? key, required this.selectedLanguage}) : super(key: key);
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DoctorProvider>(context, listen: false)
          .initializeUserPosition()
          .then((_) {
        Provider.of<DoctorProvider>(context, listen: false).getNearestDoctors();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    final doctorProvider = Provider.of<DoctorProvider>(context);
    return Scaffold(
      body: Directionality(
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

return CustomScrollView(
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
                                      const Icon(Icons.person_2_rounded, color: Color.fromARGB(255, 0, 0, 0)), 
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
                                          fontSize: 18,
                                          color: Color.fromARGB(255, 57, 57, 57),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5), 
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, color: Color.fromARGB(255, 243, 33, 33)), 
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
                              top: 0,
                              child: Consumer<AppointmentsProvider>(
                                builder: (context, appointmentProvider, _) {
                                  int appointmentNotificationCount =
                                      appointmentProvider.getNotifications().length;
                                  int demandeMedicamentNotificationCount =
                                      Provider.of<DemandeMedicamentProvider>(
                                              context,
                                              listen: false)
                                          .getNotifications()
                                          .length;
                                  int scheduledNotificationCount =
                                      appointmentProvider.getScheduledNotifications().length; // Ajout de la logique pour obtenir le nombre de notifications planifiées
                                  int totalNotifications =
                                      appointmentNotificationCount +
                                      demandeMedicamentNotificationCount +
                                      scheduledNotificationCount; // Mise à jour du total des notifications
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
                          showNotificationDialog(context);
                        },
                      ),
                              ]
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
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
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
                                MaterialPageRoute(
                                    builder: (context) => searchDoctorPage(
                                          selectedLanguage:
                                              widget.selectedLanguage,
                                        )),
                              );
                            },
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                ),
                                Expanded(
                                  child: Text(
                                    S.of(context).Search_doctor,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                const Icon(
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
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              pauseAutoPlayOnTouch: true,
                              viewportFraction: 0.8,
                              onPageChanged: (index, reason) {},
                            ),
                            items: imageAssetPaths.map((assetPath) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
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
                                S.of(context).Categories,
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
                                        builder: (context) => AllCategoriesPage(
                                              selectedLanguage:
                                                  widget.selectedLanguage,
                                            )),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
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
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: Consumer<Myprovider>(
                            builder: (context, myProvider, _) {
                              return FutureBuilder<void>(
                                future: myProvider.getCategory(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    List<CategoryModel> categories =
                                        myProvider.getCategoryModelList;
                                    return GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 3.0,
                                        mainAxisSpacing: 3.0,
                                      ),
                                      itemCount: min(categories.length, 8),
                                      itemBuilder: (context, index) {
                                        if (index < categories.length) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CategoryDetailPage(
                                                    category: categories[index],
                                                    selectedLanguage:
                                                        widget.selectedLanguage,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Card(
                                              elevation: 3,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Container(
                                                color: Colors.white,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    Expanded(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                        child: Image.network(
                                                          categories[index]
                                                              .image,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        categories[index].name,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return const SizedBox(
                                            height: 1,
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                              );
                            },
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
                                S.of(context).Top_Doctor,
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
                                        builder: (context) => AllDoctorsPage(
                                              selectedLanguage:
                                                  widget.selectedLanguage,
                                            )),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
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
                          visible: doctorProvider.doctorModelList.isNotEmpty,
                          replacement: Center(
                            child: Text(
                              S.of(context).No_doctor_found_in_your_zone,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.red),
                            ),
                          ),
                          child: SizedBox(
                            height: 160,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  min(doctorProvider.doctorModelList.length, 5),
                              itemBuilder: (BuildContext context, int index) {
                                final doctor =
                                    doctorProvider.doctorModelList[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => MedecinDetailsPage(
                                        medecin: doctor.toMap(),
                                        selectedLanguage:
                                            widget.selectedLanguage,
                                      ),
                                    ));
                                  },
                                  child: Container(
                                    width: 300,
                                    padding: const EdgeInsets.all(4),
                                    child: Card(
                                      elevation: 10,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 40,
                                            backgroundImage: AssetImage(
                                                'lib/assets/images/MediApp.png'),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  vertical: 8,
                                                  horizontal:
                                                      4), // Réduire les marges
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.category,
                                                        size: 16,
                                                        color: Color.fromRGBO(
                                                            100, 235, 182, 1),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Expanded(
                                                        child: Text(
                                                          "${S.of(context).Specialty} :${doctor.category.join(', ')}",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .calendar_today_outlined,
                                                        size: 16,
                                                        color: Color.fromRGBO(
                                                            100, 235, 182, 1),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Expanded(
                                                        child: Text(
                                                          "${S.of(context).Days} : ${doctor.workDays.join(', ')}",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                                        color: Color.fromRGBO(
                                                            100, 235, 182, 1),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        "${S.of(context).Hours} : ${doctor.startTime} - ${doctor.endTime}",
                                                        style: const TextStyle(
                                                            fontSize: 14),
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
                  );
                }
                ),
      ),
    );
  }
}

void showNotificationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(S.of(context).notificationsTitle),
        content: Directionality(
          textDirection: Localizations.localeOf(context).languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: SingleChildScrollView(
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
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            appointmentNotifications[index]
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
                const SizedBox(height: 16),
                Text(
                  S.of(context).newRequestReceived,
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
                                            demandeMedicamentNotifications[
                                                    index]
                                                .message,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            demandeMedicamentNotifications[
                                                    index]
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
  'lib/assets/images/notice_docteur2.png',
  'lib/assets/images/notice_docteur1.png',
  'lib/assets/images/notice_docteur.png',
];
