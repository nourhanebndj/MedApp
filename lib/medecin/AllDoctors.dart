import 'package:flutter/material.dart';
import 'package:mediloc/provider/myprovider.dart';
import 'package:provider/provider.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/medecin/medecindetail.dart';
import 'package:mediloc/provider/myprovider_doctor.dart';

class AllDoctorsPage extends StatefulWidget {
  final String selectedLanguage;

  const AllDoctorsPage({Key? key, required this.selectedLanguage}) : super(key: key);

  @override
  _AllDoctorsPageState createState() => _AllDoctorsPageState();
}

class _AllDoctorsPageState extends State<AllDoctorsPage> {
  late Future<void> _fetchDoctorsFuture;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchDoctorsFuture = Provider.of<DoctorProvider>(context, listen: false).getNearestDoctors();
    Provider.of<Myprovider>(context, listen: false).getCategory(); 
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<Myprovider>(context).getCategoryModelList;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).All_Doctors, style: const TextStyle(color: Colors.black)),
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
                future: _fetchDoctorsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error.toString()}'));
                  } else {
                    final doctorProvider = Provider.of<DoctorProvider>(context);
                    final doctors = doctorProvider.doctorModelList.where((doctor) {
                      return _selectedCategory == null || doctor.category.contains(_selectedCategory!);
                    }).toList();

                    if (doctors.isEmpty) {
                      return Center(
                        child: Text(
                          S.of(context).No_doctor_found_in_your_zone,
                          style: const TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (context, index) {
                          final doctor = doctors[index];
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
                              title: Text("${S.of(context).Dr} ${doctor.name}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                "${S.of(context).Specialty} :  ${doctor.category.join(', ')}\n"
                                "${S.of(context).Days}  : ${doctor.workDays.join(', ')}\n"
                                "${S.of(context).Hours} : ${doctor.startTime} - ${doctor.endTime}",
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MedecinDetailsPage(medecin: doctor.toMap(), selectedLanguage: widget.selectedLanguage),
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
