import 'package:flutter/material.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/model/pharmacie_model.dart';
import 'package:mediloc/pharmacie/pharmaciedetailspage.dart';

class PharmacistListPage extends StatelessWidget {
  final List<PharmacieModel> pharmacies;
      final String selectedLanguage; 

  PharmacistListPage(this.pharmacies,this.selectedLanguage); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(S.of(context).Search_pharmacist,
         style:const  TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
       body:Directionality(
        textDirection:selectedLanguage == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
         child: ListView.builder(
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
                leading:const  CircleAvatar(
                  backgroundImage: AssetImage("lib/assets/images/medecin.png"),
                ),
                title: Text(pharmacie.name,
                 style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  "${S.of(context).Days}: ${pharmacie.workDays.join(', ')}\n"
                  "${S.of(context).Hours}: ${pharmacie.startTime} - ${pharmacie.endTime}",
                ),
               
                onTap: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>PharmacieDetailsPage(pharmacie: pharmacie,selectedLanguage:selectedLanguage,),
                    ),
                  );
                },
              ),
            );
          },
               ),
       ),
    );
  }
}
