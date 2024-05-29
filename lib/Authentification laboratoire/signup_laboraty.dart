import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediloc/Authentification%20laboratoire/Login_laboraty.dart';
import 'package:mediloc/Authentification%20laboratoire/profillaboratory.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/model/category_laboratory.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mediloc/provider/category_laboratory_provider.dart';
import 'package:provider/provider.dart';

class Signuplaboraty extends StatefulWidget {
  final String selectedLanguage;
  const Signuplaboraty({super.key, required this.selectedLanguage});

  @override
  _SignuplaboratoryState createState() => _SignuplaboratoryState();
}

class _SignuplaboratoryState extends State<Signuplaboraty> {
  List<CategorylaboratoryModel> categorylaboratoryModelList = [];
  List<String> selectedCategories = [];
  String? selectedCategory;
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
  LatLng? selectedLocation;
  GoogleMapController? mapController;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String email = "";
  String password = "";
  String name = "";
  String phone = "";
  String? laboratoryId;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void registration(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    name = nameController.text;
    email = mailController.text.trim();
    password = passwordController.text;
    phone = phoneController.text;

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Utilisation de la variable de classe laboratoryId
        laboratoryId = user.uid;
        print('User ID: $laboratoryId');

        if (laboratoryId != null) {
          await addUser(laboratoryId!); 
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Registered Successfully",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );

          if (selectedLocation != null) {
            GeoPoint geoPointLocation = GeoPoint(
                selectedLocation!.latitude, selectedLocation!.longitude);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Profillaboratory(
                  selectedLanguage: widget.selectedLanguage,
                  name: nameController.text,
                  email: mailController.text.trim(),
                  phone: phoneController.text,
                  categorylaboratoryModelList: [],
                  selectedCategories: [],
                  selectedCategory: selectedCategory ?? '',
                  workDays: selectedWorkDays,
                  startTime: formatTimeOfDay(startTime),
                  endTime: formatTimeOfDay(endTime),
                  laboratoryId: laboratoryId!,
                  location: geoPointLocation,

                ),
              ),
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(255, 104, 137, 208),
            content: Text(
              "Password provided is too weak",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromRGBO(255, 104, 137, 208),
            content: Text(
              "Account already exists",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }
}


  Future<void> addUser(String laboratoireId) async {
    if (selectedLocation != null) {
      try {
        await FirebaseFirestore.instance
            .collection('laboratoire')
            .doc( laboratoryId)
            .set({
          ' laboratoryId':  laboratoryId,
          'name': name,
          'email': email,
          'phone': phone,
          'category': selectedCategory,
          'workDays': selectedWorkDays,
          'location':
              GeoPoint(selectedLocation!.latitude, selectedLocation!.longitude),
          'startTime': startTime?.format(context),
          'endTime': endTime?.format(context),
        });
        print("User and location added to Firestore");
      } catch (error) {
        print("Failed to add user and location to Firestore: $error");
      }
    } else {
      print("No location selected");
    }
  }

  void _showCategoryDialog() {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      Provider.of<Myproviderlaboratory>(context);
      return AlertDialog(
        title: const Text('Choose Categories'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: ListBody(
                children: categorylaboratoryModelList.map((category) {
                  bool isChecked = selectedCategories.contains(category.name);
                  return CheckboxListTile(
                    title: Text(category.name),
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value ?? false) {
                          if (!selectedCategories.contains(category.name)) {
                            selectedCategories.add(category.name);
                          }
                        } else {
                          selectedCategories.remove(category.name);
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
            child: Text(S.of(context).Done),
            onPressed: () {
              setState(() {
                selectedCategory = selectedCategories.isNotEmpty ? selectedCategories.join(', ') : 'Select Category';
              });
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
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
              child: Text(S.of(context).Done),
              onPressed: () {
                setState(() {
                  selectedWorkDays = selectedWorkDays.isNotEmpty
                      ? List.from(selectedWorkDays)
                      : [S.of(context).Select_Work_Days];
                });
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

//fonction de la localisation avec map
  void _openMapDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).Select_Your_Location),
          content: SizedBox(
            height: 300,
            width: 300,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(28.0268755, 1.6528399999999976),
                zoom: 4,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              onTap: (LatLng location) {
                setState(() {
                  selectedLocation = location;
                });
                Navigator.of(context).pop();
              },
              markers: selectedLocation != null
                  ? {
                      Marker(
                        markerId: const MarkerId('selectedLocation'),
                        position: selectedLocation!,
                      ),
                    }
                  : {},
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).Done),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleTap(LatLng tappedPoint) {
    setState(() {
      selectedLocation = tappedPoint;
      mapController?.animateCamera(CameraUpdate.newLatLng(tappedPoint));
    });
  }

  //horaire debut et fin
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

  //ui

  @override
  void initState() {
    selectedCategories = [];
    selectedWorkDays = [];
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('laboratoire_categorie').get();
    List<CategorylaboratoryModel> categories = querySnapshot.docs.map((doc) {
      return CategorylaboratoryModel(
        name: doc['name'] ?? '',
        image: doc['image'] ?? '',
        isSelected: false,
      );
    }).toList();
    setState(() {
      categorylaboratoryModelList = categories;
    });
  } catch (error) {
    print("Erreur lors de la récupération des catégories : $error");
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Directionality(
          textDirection: widget.selectedLanguage == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: SingleChildScrollView(
            child: Column(
              children: [
                  Image.asset(
                  'lib/assets/images/MediApp.png',
                  width: 100,
                  height: 100,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Text(
                        S.of(context).SignUp,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        S.of(context).Welcome_to_your_application,
                        style: const TextStyle(
                          color: Color.fromARGB(179, 96, 91, 91),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                                'Personnel Information :',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2.0,
                            horizontal: 5.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Name';
                              }
                              return null;
                            },
                            controller: nameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: S.of(context).Name,
                              hintStyle: const TextStyle(
                                fontSize: 16,
                              ),
                              prefixIcon: const Icon(
                                Icons.person,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2.0,
                            horizontal: 5.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Email';
                              }
                              if (!EmailValidator.validate(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            controller: mailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: S.of(context).Email,
                              hintStyle: const TextStyle(
                                fontSize: 16,
                              ),
                              prefixIcon: const Icon(
                                Icons.mail,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                       
                        //phone number
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2.0,
                            horizontal: 5.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Phone Number';
                              } else if (value.length != 10 ||
                                  int.tryParse(value) == null) {
                                return 'Please enter a valid 10-digit Phone Number';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            controller: phoneController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: S.of(context).Phone_Number,
                              hintStyle: const TextStyle(
                                fontSize: 16,
                              ),
                              prefixIcon: const Icon(
                                Icons.phone,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2.0,
                            horizontal: 5.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Password';
                              }
                              return null;
                            },
                            obscureText: true,
                            controller: passwordController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: S.of(context).Password,
                              hintStyle: const TextStyle(
                                fontSize: 16,
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                              height: 10,
                            ),
                             const Text(
                                'Work Information :',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                         // Field de la categorie
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      width: 1,
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.category,
                                    ),
                                    title: Text(
                                      selectedCategories.isNotEmpty
                                          ? selectedCategories.join(', ')
                                          : 'Select Category',
                                      style: TextStyle(
                                        color: selectedCategory == null
                                            ? const Color.fromARGB(
                                                255, 30, 30, 30)
                                            : const Color.fromARGB(
                                                255, 0, 0, 0),
                                        fontSize: 12,
                                      ),
                                    ),
                                    onTap: () {
                                      _showCategoryDialog();
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      width: 1,
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.calendar_today,
                                    ),
                                    title: Text(
                                      selectedWorkDays.isNotEmpty
                                          ? selectedWorkDays.join(', ')
                                          : S.of(context).Select_Work_Days,
                                      style: TextStyle(
                                        color: selectedWorkDays.isEmpty
                                            ? const Color.fromARGB(
                                                255, 34, 34, 34)
                                            : const Color.fromARGB(
                                                255, 0, 0, 0),
                                        fontSize: 12,
                                      ),
                                    ),
                                    onTap: () {
                                      _showWorkDaysDialog();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        //horaire de la journée
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      width: 1,
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      startTime == null
                                          ? S.of(context).Select_Start_Time
                                          : 'Start Time: ${startTime!.format(context)}',
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    leading: const Icon(Icons.timer),
                                    onTap: () => _selectStartTime(context),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      width: 1,
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      endTime == null
                                          ? S.of(context).Select_End_Time
                                          : 'End Time: ${endTime!.format(context)}',
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    leading: const Icon(Icons.timer_off),
                                    onTap: () => _selectEndTime(context),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                         const SizedBox(
                          height: 10,
                        ),
                        //google map integration
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: _openMapDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2.0,
                              horizontal: 5.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                width: 1,
                              ),
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.map,
                              ),
                              title: Text(
                                selectedLocation == null
                                    ? S.of(context).Select_Your_Location
                                    : 'Location Selected: ${selectedLocation.toString()}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10.0),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              registration(context);
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                              vertical: 2.0,
                              horizontal: 5.0,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(100, 235, 182, 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  registration(context);
                                }
                              },
                              child: Text(
                                S.of(context).SignUp,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              S.of(context).Already_have_an_account,
                              style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Loginlaboraty(
                                            selectedLanguage:
                                                widget.selectedLanguage,
                                          )),
                                );
                              },
                              child: Text(
                                S.of(context).Login,
                                style: const TextStyle(
                                  color: Color.fromRGBO(100, 235, 182, 1),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
      ),
    );
  }
}
