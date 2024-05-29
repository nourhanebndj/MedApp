import 'package:flutter/material.dart';
import 'package:mediloc/laboratoire/laboratorydetailpage.dart';
import 'package:mediloc/provider/category_laboratory_provider.dart';
import 'package:mediloc/provider/laboratoire_provider.dart';
import 'package:mediloc/provider/myprovider.dart';
import 'package:provider/provider.dart';
import 'package:mediloc/generated/l10n.dart';

class AlllaboratoryPage extends StatefulWidget {
  final String selectedLanguage;

  const AlllaboratoryPage({Key? key, required this.selectedLanguage}) : super(key: key);

  @override
  _AlllaboratoryPageState createState() => _AlllaboratoryPageState();
}

class _AlllaboratoryPageState extends State<AlllaboratoryPage> {
  late Future<void> _fetchlaboratoryFuture;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchlaboratoryFuture = Provider.of<LaboratoireProvider>(context, listen: false).getNearestlaboratory();
    Provider.of<Myprovider>(context, listen: false).getCategory(); // Fetch categories
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<Myproviderlaboratory>(context).getCategorylaboratoryModelList;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).All_laboratory, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Directionality(
        textDirection: widget.selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          children: [
            // Category chips
            Container(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChoiceChip(
                      label: Text(category.name),
                      selected: _selectedCategory == category.name,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedCategory = category.name;
                          } else {
                            _selectedCategory = null;
                          }
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor:const Color.fromRGBO(100, 235, 182, 1),
                      labelStyle: TextStyle(color: _selectedCategory == category.name ? Colors.white : Colors.black),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<void>(
                future: _fetchlaboratoryFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error.toString()}'));
                  } else {
                    final laboratoireProvider = Provider.of<LaboratoireProvider>(context);
                    final laboratoire = laboratoireProvider.laboratoryModelList.where((laboratoire) {
                      return _selectedCategory == null || laboratoire.category.contains(_selectedCategory!);
                    }).toList();

                    if (laboratoire.isEmpty) {
                      return Center(
                        child: Text(
                          S.of(context).No_doctor_found_in_your_zone,
                          style: const TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: laboratoire.length,
                        itemBuilder: (context, index) {
                          final laboratoires = laboratoire[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            elevation: 4.0,
                            child: ListTile(
                              tileColor: Colors.white,
                              leading: const CircleAvatar(
                                backgroundImage: AssetImage("lib/assets/images/medecin.png"),
                                radius: 30.0,
                              ),
                              title: Text(" ${laboratoires.name}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                "${S.of(context).Specialty} :  ${laboratoires.category.join(', ')}\n"
                                "${S.of(context).Days}  : ${laboratoires.workDays.join(', ')}\n"
                                "${S.of(context).Hours} : ${laboratoires.startTime} - ${laboratoires.endTime}",
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => laboratoryDetailsPage(laboratory: laboratoires.toMap(), selectedLanguage: widget.selectedLanguage),
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
          ],
        ),
      ),
    );
  }
}
