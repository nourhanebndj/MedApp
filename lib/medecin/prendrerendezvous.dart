import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/model/medecin_model.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentsPage extends StatefulWidget {
    final String selectedLanguage;
  final DoctorModel doctor;
  final String doctorId;

  const AppointmentsPage({
    Key? key,
    required this.selectedLanguage,
    required this.doctor,
    required this.doctorId,
  }) : super(key: key);

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  late String _selectedTime;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _ageController;
  String _selectedSex = 'Male';
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    print("Doctor ID in AppointmentsPage: ${widget.doctorId}");
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _ageController = TextEditingController();
    _selectedTime = _generateAvailableTimes().first;
    _selectedDay = DateTime.now();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<String>> _buildTimeDropdownItems() {
    List<String> availableTimes = _generateAvailableTimes();
    return availableTimes.map((time) {
      return DropdownMenuItem<String>(
        value: time,
        child: Text(time),
      );
    }).toList();
  }

  List<String> _generateAvailableTimes() {
    List<String> availableTimes = [];
    intl.DateFormat format12hr = intl.DateFormat("h:mm a",'en');
    intl.DateFormat format24hr = intl.DateFormat("HH:mm",'en');
   intl.DateFormat chosenFormat;

    bool is12HourFormat =
        widget.doctor.startTime.contains("AM") || widget.doctor.startTime.contains("PM");
    chosenFormat = is12HourFormat ? format12hr : format24hr;

    DateTime today = DateTime.now();
    try {
      DateTime startDateTime = chosenFormat.parse(widget.doctor.startTime);
      DateTime endDateTime = chosenFormat.parse(widget.doctor.endTime);

      startDateTime =
          DateTime(today.year, today.month, today.day, startDateTime.hour, startDateTime.minute);
      endDateTime = DateTime(today.year, today.month, today.day, endDateTime.hour, endDateTime.minute);

      if (endDateTime.isBefore(startDateTime)) {
        endDateTime = endDateTime.add(const Duration(days: 1));
      }

      while (startDateTime.isBefore(endDateTime)) {
        availableTimes.add(chosenFormat.format(startDateTime));
        startDateTime = startDateTime.add(const Duration(hours: 1));
      }

      String finalSlot = chosenFormat.format(endDateTime);
      if (!availableTimes.contains(finalSlot)) {
        availableTimes.add(finalSlot);
      }
    } catch (e) {
      print("Error parsing time: $e");
    }

    return availableTimes;
  }

  void _bookAppointment() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("User not logged in");
      return;
    }

    final now = DateTime.now();
    final appointment = {
      'doctorId': widget.doctor.doctorId,
      'userId': userId,
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'sexe': _selectedSex,
      'age': _ageController.text,
      'selectedDay': intl.DateFormat('yyyy-MM-dd').format(_selectedDay),
      'selectedTime': _selectedTime,
      'appointmentDate': Timestamp.fromDate(now),
      'status': 'pending', 
    };

    try {
      await FirebaseFirestore.instance.collection('Prendre_Rendez_Vous').add(appointment);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 48),
                  const SizedBox(width: 8),
                  Text(
                    S.of(context).appointmentRegistered,
                    style:const  TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 const  Icon(Icons.arrow_back, color: Colors.black, size: 18),
                  TextButton(
                    child:  Text(
                      S.of(context).backToHomePage,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error booking appointment: $e");
      // Gérez les erreurs lors de l'ajout du rendez-vous
    }
  }

  bool _isDayEnabled(DateTime day) {
  // Convertir le jour de la semaine actuel en chaîne correspondant au nom du jour
  String dayOfWeek = intl.DateFormat('EEEE','en').format(day);

  // Vérifier si cette chaîne fait partie des jours de travail
  return widget.doctor.workDays.contains(dayOfWeek);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(100, 235, 182, 1),
        centerTitle: true,
        title: Text(
          'Book Appointment with  \n Dr.${widget.doctor.name}',
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            letterSpacing: 0.53,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Container(
            padding: const EdgeInsets.only(
              left: 30,
              bottom: 10,
            ),
          ),
        ),
      ),
      body: Directionality(
        textDirection:widget.selectedLanguage == 'ar'? TextDirection.rtl: TextDirection.ltr,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                 Text(
                  S.of(context).patientInformation,
                  style:const  TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText:S.of(context).firstName,
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText:S.of(context).lastName,
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedSex,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSex = newValue!;
                          });
                        },
                        items: <String>['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText:S.of(context).sexe,
                          prefixIcon: const Icon(Icons.transgender),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                              color: Colors.black26,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          labelText:S.of(context).age,
                          prefixIcon: const Icon(Icons.cake),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                              color: Colors.black26,
                              width: 1.0,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TableCalendar(
                  locale: 'en',
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                    });
                  },
                  calendarFormat: CalendarFormat.month,
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: DateTime.now(),
                  enabledDayPredicate: _isDayEnabled, 
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedTime,
                  onChanged: (value) {
                    setState(() {
                      _selectedTime = value!;
                    });
                  },
                  items: _buildTimeDropdownItems(),
                  decoration: InputDecoration(
                    labelText:S.of(context).selectWorkTime,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                        width: 1.0,
                      ),
                    ),
                    prefixIcon: const Icon(Icons.timer_outlined),
                  ),
                ),
                const SizedBox(height: 20),
                SlideAction(
                  borderRadius:20,
                  elevation:0,
                  innerColor:Colors.white,
                  outerColor: const Color.fromRGBO(100, 235, 182, 1),
                  sliderButtonIcon:const Icon(
                    Icons.book,
                    color: Color.fromRGBO(100, 235, 182, 1)),
                  sliderButtonIconPadding:10,
                  text:S.of(context).bookAppointment,
                  textStyle:const TextStyle(
                    color:Colors.white,
                    fontSize:20,
                  ),
                  sliderRotate: false,
                  onSubmit: () {
                    if (_firstNameController.text.isEmpty ||
                        _lastNameController.text.isEmpty ||
                        _ageController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            icon: Icon(
                              Icons.error_outline,
                              color: Colors.red[700],
                              size: 50,
                            ),
                            content: const Text(
                              "Please fill in all the fields.",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("Close"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }
                    _bookAppointment();
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
