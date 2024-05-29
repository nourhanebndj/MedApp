import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/model/category_model.dart';
import 'package:mediloc/medecin/medecindetail.dart';

class CategoryDetailPage extends StatefulWidget {
  final CategoryModel category;
   final String selectedLanguage;

  const CategoryDetailPage({Key? key, required this.category,required this.selectedLanguage}) : super(key: key);

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  List<Map<String, dynamic>> categoryDetails = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> fetchedData = await FirebaseFirestore.instance
          .collection('medecin')
          .where('category', isEqualTo: widget.category.name)
          .get();
      setState(() {
        categoryDetails = fetchedData.docs.map((doc) {
          GeoPoint location = doc.data()['location'] as GeoPoint? ?? const GeoPoint(0, 0);
          return {
            'doctorId': doc.id,
            'name': doc['name'],
            'email': doc['email'],
            'phone': doc['phone'],
            'category': doc['category'],
            'workDays': doc['workDays'],
            'startTime': doc['startTime'],
            'endTime': doc['endTime'],
            'location': location,
          };
        }).toList();
      });
    } catch (e) {
      print("Error fetching medecin details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:Directionality(
        textDirection: widget.selectedLanguage == 'ar'? TextDirection.rtl: TextDirection.ltr,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: categoryDetails.length,
                  itemBuilder: (context, index) {
                    return _buildMedecinCard(context, categoryDetails[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedecinCard(BuildContext context, Map<String, dynamic> medecin) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      
      child: ListTile(
         tileColor: Colors.white,
        leading: const CircleAvatar(
          backgroundImage: AssetImage('lib/assets/images/medecin.png'), 
          radius: 30.0,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "${S.of(context).Dr} ${medecin['name']}",

                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Text(
          "${S.of(context).Specialty} ${medecin['category']}\n ${S.of(context).phone} ${medecin['phone']}\n${S.of(context).Days} ${medecin['workDays'].join(', ')}\n${S.of(context).Hours} ${medecin['startTime']} - ${medecin['endTime']}",

          style: const TextStyle(fontSize: 14),
        ),
        isThreeLine: true,
        onTap: () {
          Navigator.push(
    context,
    MaterialPageRoute(
            builder: (context) => MedecinDetailsPage(medecin: medecin,selectedLanguage:widget.selectedLanguage,),
    ),
  );
        },
      ),
    );
  }
}
