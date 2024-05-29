import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mediloc/SearchPages/search_laboratory.dart';
import 'package:mediloc/categories_laboratoire/All_categories_laboratory.dart';
import 'package:mediloc/categories_laboratoire/categorieslaboratorydetailspage.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/laboratoire/All_laboratory.dart';
import 'package:mediloc/laboratoire/laboratorydetailpage.dart';
import 'package:mediloc/model/category_laboratory.dart';
import 'package:mediloc/provider/category_laboratory_provider.dart';
import 'package:mediloc/provider/laboratoire_provider.dart';
import 'package:provider/provider.dart';

class Homelaboratory extends StatefulWidget {
  final String selectedLanguage;
  const Homelaboratory({Key? key, required this.selectedLanguage})
      : super(key: key);
  @override
  _HomelaboratoryState createState() => _HomelaboratoryState();
}

class _HomelaboratoryState extends State<Homelaboratory> {
  Future<void> _refreshData() async {
    await Provider.of<LaboratoireProvider>(context, listen: false)
        .initializeUserPosition();
    await Provider.of<LaboratoireProvider>(context, listen: false)
        .getNearestlaboratory();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LaboratoireProvider>(context, listen: false)
          .initializeUserPosition()
          .then((_) {
        Provider.of<LaboratoireProvider>(context, listen: false)
            .getNearestlaboratory();
        Provider.of<Myproviderlaboratory>(context, listen: false)
            .getCategorylaboratoire();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final laboratoireProvider = Provider.of<LaboratoireProvider>(context);

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
                                  const SizedBox(height:10,),
                                 Row(
                                    children: [
                                      const Icon(Icons.location_on, color: Color.fromARGB(255, 243, 33, 33)), 
                                      const SizedBox(width: 5), 
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
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
                                    ],
                                  )

                                ],
                              ),
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
                                  builder: (context) => searchLaboratoryPage(
                                    selectedLanguage: widget.selectedLanguage,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                ),
                                Expanded(
                                  child: Text(
                                    S.of(context).Search_laboratory,
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
                                      builder: (context) =>
                                          AlllaboratoryCategoriesPage(
                                        selectedLanguage:
                                            widget.selectedLanguage,
                                      ),
                                    ),
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
                          child: Consumer<Myproviderlaboratory>(
                            builder: (context, Myproviderlaboratory, _) {
                              return FutureBuilder<void>(
                                future: Myproviderlaboratory
                                    .getCategorylaboratoire(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    List<CategorylaboratoryModel> categories =
                                        Myproviderlaboratory
                                            .getCategorylaboratoryModelList;
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
                                                      CategorylaboratoryDetailPage(
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
                                S.of(context).Top_laboratory,
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
                                      builder: (context) => AlllaboratoryPage(
                                        selectedLanguage:
                                            widget.selectedLanguage,
                                      ),
                                    ),
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
                          visible: laboratoireProvider
                              .laboratoryModelList.isNotEmpty,
                          replacement: Center(
                            child: Text(
                              S.of(context).No_laboratory_found_in_your_zone,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.red),
                            ),
                          ),
                          child: SizedBox(
                            height: 160,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: min(
                                  laboratoireProvider
                                      .laboratoryModelList.length,
                                  5),
                              itemBuilder: (BuildContext context, int index) {
                                final laboratoire = laboratoireProvider
                                    .laboratoryModelList[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          laboratoryDetailsPage(
                                        laboratory: laboratoire.toMap(),
                                        selectedLanguage:
                                            widget.selectedLanguage,
                                      ),
                                    ));
                                  },
                                  child: Container(
                                    width: 350,
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
                                                        Icons.biotech,
                                                        size: 30,
                                                        color: Colors.blue,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        "${S.of(context).Laboratory} ${laboratoire.name}",
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
                                                          "${S.of(context).Specialty} :${laboratoire.category.join(', ')}",
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
                                                          "${S.of(context).Days} : ${laboratoire.workDays.join(', ')}",
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
                                                        "${S.of(context).Hours} : ${laboratoire.startTime} - ${laboratoire.endTime}",
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
                },
              ),
      ),
    );
  }
}

List<String> imageAssetPaths = [
  'lib/assets/images/laboratoire_notice2.png',
  'lib/assets/images/laboratoire_notice.png',
  'lib/assets/images/laboratoire_notice1.png',
];
