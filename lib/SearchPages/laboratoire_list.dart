import 'package:flutter/material.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/laboratoire/laboratorydetailpage.dart';
import 'package:mediloc/model/laboratory_model.dart';

class laboratoireListPage extends StatelessWidget {
  final List<laboratoryModel> searchResults;
   final String selectedLanguage;

  laboratoireListPage(this.searchResults,this.selectedLanguage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(S.of(context).Search_laboratory,
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
            final laboratoire = searchResults[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 4.0,
              child: ListTile(
                leading: const  CircleAvatar(
                  backgroundImage: AssetImage("lib/assets/images/labo.png"),
                ),
                 title: Text(
                  "${S.of(context).Laboratory} ${laboratoire.name}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  "${S.of(context).Specialty} ${laboratoire.category.isNotEmpty ? laboratoire.category.join(', ') :'not specified'}\n"
                  "${S.of(context).Days} ${laboratoire.workDays.join(', ')}\n"
                  "${S.of(context).Hours} ${laboratoire.startTime} - ${laboratoire.endTime}",
                ), 

                isThreeLine: true,
               onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => laboratoryDetailsPage(laboratory: laboratoire.toMap(),selectedLanguage:selectedLanguage,),
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
