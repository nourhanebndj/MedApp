import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mediloc/authentification%20pharmacie/ProfilScreenPharmacie.dart';
import 'package:mediloc/authentification%20pharmacie/welcomepharmacie.dart';
import 'package:mediloc/generated/l10n.dart';

class EditProfilepharmacieScreen extends StatefulWidget {
  final ProfilScreenPharmacie pharmacie;
    final String selectedLanguage;


  const EditProfilepharmacieScreen({Key? key, required this.pharmacie,required this.selectedLanguage})
      : super(key: key);

  @override
  _EditProfilepharmacieScreenState createState() => _EditProfilepharmacieScreenState();
}

class _EditProfilepharmacieScreenState extends State<EditProfilepharmacieScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  List<String> availableWorkDays = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];
  List<String> selectedWorkDays = [];
  String? pharmacieId;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<bool> selectedWorkdays = List.filled(7, false);
  LatLng? selectedLocation;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.pharmacie.name);
    emailController = TextEditingController(text: widget.pharmacie.email);
    phoneController = TextEditingController(text: widget.pharmacie.phone);
    startTime = stringToTimeOfDay(widget.pharmacie.startTime);
    endTime = stringToTimeOfDay(widget.pharmacie.endTime);
    selectedWorkDays = widget.pharmacie.workDays;
    selectedLocation = LatLng(widget.pharmacie.location.latitude,
        widget.pharmacie.location.longitude);
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

  String formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return 'Not set';
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  TimeOfDay? stringToTimeOfDay(String? timeString) {
    if (timeString == null || !timeString.contains(":")) {
      return null;
    }
    final parts = timeString.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onTap(LatLng location) {
    setState(() {
      selectedLocation = location;
    });
  }

  void _showWorkDaysDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).Select_Work_Days),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: ListBody(
                  children: availableWorkDays.map((day) {
                    bool isChecked = selectedWorkDays.contains(day);
                    return CheckboxListTile(
                      title: Text(day),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value ?? false) {
                            if (!selectedWorkDays.contains(day)) {
                              selectedWorkDays.add(day);
                            }
                          } else {
                            selectedWorkDays.remove(day);
                          }
                        });
                      },
                      checkColor: Colors.white,
                      activeColor: const Color.fromRGBO(100, 235, 182, 1),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child:  Text(S.of(context).Done),
              onPressed: () {
                setState(() {
                  selectedWorkDays = selectedWorkDays.isNotEmpty
                      ? List.from(selectedWorkDays)
                      : ['Select Work Days'];
                });
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(
          S.of(context).edit_profil),
        centerTitle: true,
      ),
      body:Directionality(
        textDirection:
            widget.selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              buildTextField(S.of(context).Name, nameController, Icons.person),
              buildTextField(S.of(context).Email, emailController, Icons.mail),
              buildTextField(S.of(context).phone, phoneController, Icons.phone),
              Row(
                children: [
                  Expanded(
                    child: buildTimePicker(S.of(context).starttime, startTime,
                        (newTime) => setState(() => startTime = newTime)),
                  ),
                  Expanded(
                    child: buildTimePicker(S.of(context).endtime, endTime,
                        (newTime) => setState(() => endTime = newTime)),
                  ),
                ],
              ),
              buildWorkDaysButton(S.of(context).work_days, _showWorkDaysDialog),
              const SizedBox(height: 20),
              SizedBox(
                height: 300, 
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: selectedLocation ??
                        const LatLng(37.77483,
                            -122.41942), 
                    zoom: 12.0,
                  ),
                  onTap: _onTap,
                  markers: {
                    if (selectedLocation != null)
                      Marker(
                        markerId: const MarkerId('selectedLocation'),
                        position: selectedLocation!,
                      ),
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(100, 235, 182, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  S.of(context).saveChange,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: confirmDeleteProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child:  Text(
                  S.of(context).delete,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 Widget buildWorkDaysButton(String label, Function onPressed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            color: Color.fromARGB(255, 204, 203, 203),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today,
              color: Color.fromRGBO(100, 235, 182, 1)),
          const SizedBox(width: 10),
          Expanded(
            child: TextButton(
              onPressed: onPressed as void Function()?,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              child: Row(
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 16, color: Color.fromARGB(221, 0, 0, 0))),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
      String label, TextEditingController controller, IconData iconData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            color: Color.fromARGB(255, 204, 203, 203),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(iconData, color:const Color.fromRGBO(100, 235, 182, 1)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                labelStyle:
                    const TextStyle(fontSize: 16, color: Colors.black87),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

 void updateProfile() async {
  try {
    // Récupérer l'ID du laboratoire
    String pharmacieId = widget.pharmacie.pharmacieId;

    // Mettre à jour le profil dans Firestore sans modifier l'ID
    await FirebaseFirestore.instance
        .collection('Pharmacie')
        .doc(pharmacieId)
        .update({
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'startTime': formatTimeOfDay(startTime),
      'endTime': formatTimeOfDay(endTime),
      'workDays': selectedWorkDays, 
      'location': GeoPoint(selectedLocation!.latitude, selectedLocation!.longitude),
    });

    setState(() {
  // Créer une copie de l'objet pharmacie en conservant les valeurs des autres propriétés
  ProfilScreenPharmacie updatedPharmacie = ProfilScreenPharmacie(
    selectedLanguage: widget.pharmacie.selectedLanguage,
    name: nameController.text.isNotEmpty ? nameController.text : widget.pharmacie.name,
    email: emailController.text.isNotEmpty ? emailController.text : widget.pharmacie.email,
    phone: phoneController.text.isNotEmpty ? phoneController.text : widget.pharmacie.phone,
    workDays: selectedWorkDays.isNotEmpty ? selectedWorkDays : widget.pharmacie.workDays,
    pharmacieId: widget.pharmacie.pharmacieId,
    startTime: formatTimeOfDay(startTime), 
    endTime: formatTimeOfDay(endTime), 
    location: widget.pharmacie.location,
  );

  if (selectedLocation != null) {
    selectedLocation = LatLng(updatedPharmacie.location.latitude, updatedPharmacie.location.longitude);
  }
});

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).profileUpdated)),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${S.of(context).updateError}: $e')),
    );
  }
}


 void confirmDeleteProfile() async {
  bool confirm = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(S.of(context).confirmDeletion),
        content: Text(S.of(context).confirmDeletionMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              S.of(context).delete,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  ) ??
  false;

  if (confirm) {
    deleteProfile();
  }
}


  void deleteProfile() async {
    try {
      await FirebaseFirestore.instance
          .collection('Pharmacie')
          .doc(widget.pharmacie.pharmacieId)
          .delete();
      // Redirection vers la page d'accueil après suppression du compte
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePharmaciePage(selectedLanguage:widget.selectedLanguage,)),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).deleteSuccess)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${S.of(context).deleteError}: $e')),
      );
    }
  }

  Widget buildTimePicker(
      String label, TimeOfDay? time, ValueChanged<TimeOfDay?> onSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            color: Color.fromARGB(255, 204, 203, 203),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.timer, color: Color.fromRGBO(100, 235, 182, 1)),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: time ?? TimeOfDay.now(),
                );
                if (picked != null && picked != time) {
                  onSelected(picked);
                }
              },
              child: Text(
                time == null
                    ? 'Select $label'
                    : '$label: ${time.format(context)}',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWorkdaysSelector() {
    return Column(
      children: List<Widget>.generate(7, (index) {
        String day = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index];
        return CheckboxListTile(
          title: Text(day),
          value: selectedWorkdays[index],
          onChanged: (bool? value) {
            setState(() {
              selectedWorkdays[index] = value!;
            });
          },
        );
      }),
    );
  }
}
