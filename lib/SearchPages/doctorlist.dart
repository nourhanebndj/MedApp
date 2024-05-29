import 'package:flutter/material.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/medecin/medecindetail.dart';
import 'package:mediloc/model/medecin_model.dart';

class DoctorListPage extends StatelessWidget {
  final List<DoctorModel> searchResults;
   final String selectedLanguage;

  DoctorListPage(this.searchResults,this.selectedLanguage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(S.of(context).Search_Doctor,
           style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:Directionality(
        textDirection:selectedLanguage == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final doctor = searchResults[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 4.0,
              child: ListTile(
                leading: const  CircleAvatar(
                  backgroundImage: AssetImage("lib/assets/images/medecin.png"),
                ),
                 title: Text(
                  "${S.of(context).Dr} ${doctor.name}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  "${S.of(context).Specialty}: ${doctor.category.isNotEmpty ? doctor.category.join(', ') :'not specified'}\n"
                  "${S.of(context).Days}: ${doctor.workDays.join(', ')}\n"
                  "${S.of(context).Hours}: ${doctor.startTime} - ${doctor.endTime}",
                ), 

                isThreeLine: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MedecinDetailsPage(medecin: doctor.toMap(),selectedLanguage:selectedLanguage,),
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
