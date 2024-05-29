import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mediloc/SearchPages/pharmacistList.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/model/pharmacie_model.dart';
import 'package:mediloc/provider/myproviderpharmacie.dart';

import 'package:provider/provider.dart';

class searchPharmaciePage extends StatefulWidget {
  final String selectedLanguage;
  const searchPharmaciePage({Key? key, required this.selectedLanguage}) : super(key: key);

  @override
  _SearchPharmaciePageState createState() => _SearchPharmaciePageState();
}

class _SearchPharmaciePageState extends State<searchPharmaciePage> {
  List<String> workDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  List<bool> isSelectedWorkDays = List.generate(7, (_) => false);
  String pharmacyName = ""; 
  LatLng? selectedLocation;

  GoogleMapController? mapController;
  final LatLng _center = const LatLng(36.737232, 3.086472); 
  Set<Marker> markers = {};

  TimeOfDay? startTime;
  TimeOfDay? endTime;
  
  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != startTime) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != endTime) {
      setState(() {
        endTime = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PharmacieProvider>(context, listen: false).initializeUserPosition();
      Provider.of<PharmacieProvider>(context, listen: false).getPharmacies();
    });
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 3;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Search_pharmacist,
          style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: widget.selectedLanguage == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(S.of(context).Pharmacist_Name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: S.of(context).Enter_pharmacist_name,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  hintText: S.of(context).Pharmacist_Name,
                ),
                onChanged: (value) {
                  setState(() {
                    pharmacyName = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Text(S.of(context).work_days, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: workDays.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 11,
                  mainAxisSpacing: 9,
                  childAspectRatio: (1 / 0.5),
                ),
                itemBuilder: (context, index) {
                  // Vérifier si le jour est sélectionné ou non
                  bool isSelected = isSelectedWorkDays[index];
              
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelectedWorkDays[index] = !isSelectedWorkDays[index];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? const Color.fromRGBO(100, 235, 182, 1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color:const Color.fromRGBO(100, 235, 182, 1)),
                      ),
                      child: Center(
                        child: Text(
                          workDays[index],
                          style: TextStyle(
                            // Utiliser la couleur de texte blanche après la sélection
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(S.of(context).Select_Hours, style: Theme.of(context).textTheme.titleLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectStartTime(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          color:const Color.fromARGB(255, 231, 247, 241),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer, color:Color.fromRGBO(100, 235, 182, 1),),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                startTime == null
                                    ? S.of(context).Select_Start_Time
                                    : '${S.of(context).Start}: ${startTime!.format(context)}',
                                style: TextStyle(color: startTime == null ? const Color.fromARGB(255, 9, 9, 9) : Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectEndTime(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          color:const Color.fromARGB(255, 231, 247, 241),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer_off, color: Color.fromRGBO(100, 235, 182, 1),),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                endTime == null
                                    ? S.of(context).Select_End_Time
                                    : '${S.of(context).End}: ${endTime!.format(context)}',
                                style: TextStyle(color: endTime == null ?const Color.fromARGB(255, 0, 0, 0) : Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(S.of(context).Select_Location, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              SizedBox(
                height: 200.0,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 11.0,
                  ),
                  markers: markers,
                  myLocationEnabled: true,
                  zoomControlsEnabled: true,
                  onTap: _selectLocation,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (isSelectedWorkDays.every((element) => element == false)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          S.of(context).Please_select_at_least_one_workday,
                          style: const TextStyle(color: Colors.red),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    );
                  } else if (selectedLocation == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          S.of(context).Please_select_a_location,
                          style:const  TextStyle(color: Colors.red),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    );
                  } else if (startTime == null || endTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          S.of(context).Please_select_both_start_and_end_time,
                          style: const TextStyle(color: Colors.red),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    );
                  } else {
                    List<String> selectedWorkDays = [];
                    for (int i = 0; i < isSelectedWorkDays.length; i++) {
                      if (isSelectedWorkDays[i]) {
                        selectedWorkDays.add(workDays[i]);
                      }
                    }
        
                    List<PharmacieModel> searchResults = Provider.of<PharmacieProvider>(context, listen: false).searchPharmacies(
                      pharmacyName: pharmacyName,
                      workDays: selectedWorkDays,
                      selectedLocation: selectedLocation!,
                      startTime:startTime,
                      endTime:endTime,
                    );
                    if (searchResults.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            S.of(context).No_doctor_found_please_reset,
                            style:const  TextStyle(color: Colors.red),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PharmacistListPage(searchResults,widget.selectedLanguage)
                                ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(100, 235, 182, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: Text(S.of(context).Search_pharmacist,
                style:const TextStyle(color:Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _selectLocation(LatLng position) {
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId("selectedLocation"),
          position: position,
        ),
      );
      selectedLocation = position;
    });
  }
}

