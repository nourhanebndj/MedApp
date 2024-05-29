import 'package:flutter/material.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/pharmacie/pharmaciedetailspage.dart';
import 'package:mediloc/provider/myproviderpharmacie.dart';
import 'package:provider/provider.dart';

class AllPharmaciePage extends StatefulWidget {
  final String selectedLanguage;
  const AllPharmaciePage({Key? key, required this.selectedLanguage}) : super(key: key);
  @override
  _AllPharmaciePageState createState() => _AllPharmaciePageState();
}

class _AllPharmaciePageState extends State<AllPharmaciePage> {
  late Future _fetchNearestPharmaciesFuture;
  

  @override
  void initState() {
    super.initState();
    _fetchNearestPharmaciesFuture = 
        Provider.of<PharmacieProvider>(context, listen: false).getNearestPharmacies();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(S.of(context).All_pharmacist, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:Directionality(
        textDirection: widget.selectedLanguage == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child:FutureBuilder<void>(
  future: _fetchNearestPharmaciesFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error.toString()}'));
    } else {
      final pharmacieProvider = Provider.of<PharmacieProvider>(context);
      final pharmacies = pharmacieProvider.pharmacieModelList;
      
      if (pharmacies.isEmpty) {
        return Center(
          child: Text(
            S.of(context).No_pharmacist_found_in_your_zone,
            style:const  TextStyle(
              fontSize:16,color:Colors.red,
            ),
            ));
      } else {
        return ListView.builder(
          itemCount: pharmacies.length,
          itemBuilder: (context, index) {
            final pharmacie = pharmacies[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 4.0,
              child: ListTile(
                tileColor: Colors.white,
                leading: const CircleAvatar(
                  backgroundImage: AssetImage("lib/assets/images/pharmacien.png"),
                  radius: 30.0,
                ),
                title: Text(pharmacie.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                   "${S.of(context).phone} ${pharmacie.phone}\n"
                  "${S.of(context).Days} ${pharmacie.workDays.join(', ')}\n"
                  "${S.of(context).Hours} ${pharmacie.startTime} - ${pharmacie.endTime}",
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PharmacieDetailsPage(pharmacie: pharmacie,selectedLanguage:widget.selectedLanguage,),
                    ),
                  );
                },
              ),
            );
          },
        );
      }
    }
  },
),

      ),
    );
  }
}
