import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediloc/generated/l10n.dart';

class AllAppointments extends StatefulWidget {
  final String userId;
  final String selectedLanguage;

  const AllAppointments({Key? key, required this.userId, required this.selectedLanguage}) : super(key: key);

  @override
  _AllAppointmentsState createState() => _AllAppointmentsState();
}

class _AllAppointmentsState extends State<AllAppointments> {
  String _selectedStatus = 'All'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        title: Text(
          S.of(context).myAppointments,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: widget.selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: ['All', 'Accepted', 'Rejected', 'Pending'].map((status) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ChoiceChip(
                      label: Text(status),
                      selected: _selectedStatus == status,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedStatus = status;
                        });
                      },
                      backgroundColor: Colors.white, 
                      selectedColor:const Color.fromRGBO(100, 235, 182, 1), 
                      labelStyle: TextStyle(
                        color: _selectedStatus == status ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Prendre_Rendez_Vous')
                    .where('userId', isEqualTo: widget.userId)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text(S.of(context).error + ': ${snapshot.error}'));
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(child: Text(S.of(context).noAppointmentsFound));
                  }

                  final sortedAppointments = snapshot.data!.docs.toList()
                    ..sort((a, b) {
                      final aDate = a['appointmentDate'] as Timestamp;
                      final bDate = b['appointmentDate'] as Timestamp;
                      return bDate.compareTo(aDate);
                    });

                  var filteredAppointments = sortedAppointments.where((doc) {
                    return _selectedStatus == 'All' || doc['status'] == _selectedStatus.toLowerCase();
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredAppointments.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot appointment = filteredAppointments[index];
                      String firstName = appointment['firstName'];
                      String lastName = appointment['lastName'];
                      String selectedDay = appointment['selectedDay'];
                      String selectedTime = appointment['selectedTime'];
                      String doctorId = appointment['doctorId'];
                      String status = appointment['status'] ?? '';

                      DateTime appointmentDateTime = DateTime.parse(selectedDay);
                      DateTime now = DateTime.now();
                      Duration timeUntilAppointment = appointmentDateTime.difference(now);

                      String remainingTime = '';
                      if (status == 'accepted' && !timeUntilAppointment.isNegative) {
                        int days = timeUntilAppointment.inDays;
                        int hours = timeUntilAppointment.inHours % 24;
                        int minutes = timeUntilAppointment.inMinutes % 60;
                        remainingTime = (days > 0 ? '$days d ' : '') + (hours > 0 ? '$hours h ' : '') + '$minutes min';
                      } else if (status == 'accepted' && timeUntilAppointment.isNegative) {
                        remainingTime = S.of(context).expired;
                      }

                      IconData statusIcon;
                      Color statusColor;
                      switch (status) {
                        case 'accepted':
                          statusIcon = Icons.check_circle;
                          statusColor = Colors.green;
                          break;
                        case 'rejected':
                          statusIcon = Icons.cancel;
                          statusColor = Colors.red;
                          break;
                        default:
                          statusIcon = Icons.timer_outlined;
                          statusColor = const Color.fromARGB(255, 52, 52, 52);
                      }

                      return doctorId.isNotEmpty ? FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('medecin').doc(doctorId).get(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> doctorSnapshot) {
                          if (doctorSnapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (doctorSnapshot.hasError) {
                            return Text(S.of(context).error + ': ${doctorSnapshot.error}');
                          }

                          if (!doctorSnapshot.hasData || !doctorSnapshot.data!.exists) {
                            return const Text('Doctor not found');
                          }

                          String doctorName = doctorSnapshot.data!['name'];
                          String doctorCategory = doctorSnapshot.data!['category'];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        "lib/assets/images/rendez-vous-chez-le-medecin.png",
                                        width: 50,
                                        height: 50,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '$firstName $lastName',
                                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '${S.of(context).Doctor}: $doctorName',
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              '${S.of(context).category}: $doctorCategory',
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time, color: Color.fromRGBO(100, 235, 182, 1)),
                                        const SizedBox(width: 5),
                                        Text(
                                          '${S.of(context).accessTime}: $selectedTime',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(width: 30),
                                        const Icon(Icons.calendar_month, color:Color.fromRGBO(100, 235, 182, 1)),
                                        const SizedBox(width: 5),
                                        Text(
                                          '${S.of(context).calendarMonth}: $selectedDay',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(statusIcon, color: statusColor),
                                            const SizedBox(width: 5),
                                            Text(status.toUpperCase(), style: TextStyle(fontSize: 16, color: statusColor)),
                                          ],
                                        ),
                                        Center(
                                      child: Text(
                                         remainingTime,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.lightGreen),
                                      ),
                                    ),

                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          );
                        },
                      ) : Container(height: 0);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
