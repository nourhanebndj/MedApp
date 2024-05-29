import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediloc/generated/l10n.dart';

class AllMedicationRequests extends StatefulWidget {
  final String userId;
  final String selectedLanguage;

  const AllMedicationRequests({Key? key, required this.userId, required this.selectedLanguage}) : super(key: key);

  @override
  _AllMedicationRequestsState createState() => _AllMedicationRequestsState();
}

class _AllMedicationRequestsState extends State<AllMedicationRequests> {
  String _selectedStatus = 'All'; // Filter status

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
          S.of(context).myMedicationRequests,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
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
                    selectedColor: const Color.fromRGBO(100, 235, 182, 1),
                    labelStyle: TextStyle(
                      color: _selectedStatus == status ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Directionality(
              textDirection: widget.selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Demande_medicament')
                    .where('userId', isEqualTo: widget.userId)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('${S.of(context).error}: ${snapshot.error}'));
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(child: Text(S.of(context).noMedicationRequestsFound));
                  }

                  final requests = snapshot.data!.docs.where((doc) {
                    return _selectedStatus == 'All' || doc['status'].toString().toLowerCase() == _selectedStatus.toLowerCase();
                  }).toList();

                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot request = requests[index];
                      String firstName = request['firstName'] ?? '';
                      String pharmacieId = request['pharmacieId'] ?? '';
                      String age = request['Age'] ?? '';
                      String status = request['status'] ?? '';
                      String text = request['text'] ?? '';
                      String? rejectionNote = request['note'] as String?;

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('Pharmacie').doc(pharmacieId).get(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> pharmacistSnapshot) {
                          if (pharmacistSnapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (pharmacistSnapshot.hasError) {
                            return Center(child: Text('${S.of(context).error}: ${pharmacistSnapshot.error}'));
                          }

                          if (!pharmacistSnapshot.hasData || !pharmacistSnapshot.data!.exists) {
                            return Center(child: Text(S.of(context).pharmacistNotFound));
                          }

                          String pharmacistName = pharmacistSnapshot.data!['name'];
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

                          // Formatter la date
                          DateTime requestDate = request['RequestDate'].toDate();
                          String formattedDate = '${requestDate.year}/${requestDate.month}/${requestDate.day}';

                          return InkWell(
                            onTap: () {},
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (rejectionNote != null && rejectionNote.isNotEmpty) 
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.warning_amber_sharp,
                                                  color: Colors.black,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  '${S.of(context).note}: $rejectionNote',
                                                  style: const TextStyle(fontSize: 20),
                                                ),
                                              ],
                                            ),
                                          ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(right: 8.0),
                                              child: CircleAvatar(
                                                backgroundImage: AssetImage('lib/assets/images/pharmacien.png'),
                                                radius: 30,
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${S.of(context).patient}: $firstName',
                                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '${S.of(context).Pharmacist}: $pharmacistName',
                                                    style: const TextStyle(fontSize: 16),
                                                  ),
                                                  Text(
                                                    '${S.of(context).age} $age',
                                                    style: const TextStyle(fontSize: 16),
                                                  ),
                                                  Text(
                                                    '${S.of(context).medicationList}: $text',
                                                    style: const TextStyle(fontSize: 16),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            statusIcon,
                                                            color: statusColor,
                                                          ),
                                                          const SizedBox(width: 5),
                                                          Text(
                                                            status.toUpperCase(),
                                                            style: TextStyle(fontSize: 16, color: statusColor),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        formattedDate,
                                                        style: const TextStyle(fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
