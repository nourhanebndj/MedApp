import 'package:flutter/material.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/provider/prendre_rendez_vous_provider.dart';
import 'package:provider/provider.dart'; 
import 'package:mediloc/model/prendre_rendez_vous_model.dart';

class AppointmentList extends StatefulWidget {
  final String doctorId;
  final String selectedLanguage;

  const AppointmentList({
    Key? key,
    required this.selectedLanguage,
    required this.doctorId,
  }) : super(key: key);

  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppointmentsProvider>(context, listen: false)
          .loadAppointmentsForDoctor(widget.doctorId);
    });
  }
Future<void> _refreshAppointments() async {
    await Provider.of<AppointmentsProvider>(context, listen: false)
          .loadAppointmentsForDoctor(widget.doctorId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myAppointments),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: widget.selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: Consumer<AppointmentsProvider>(
          builder: (context, provider, _) {
            if (provider.appointments.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: provider.appointments.length,
                itemBuilder: (context, index) {
                  final appointment = provider.appointments[index];
                  return AppointmentCard(appointment: appointment);
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData statusIcon;
    Color statusColor;
    switch (appointment.status) {
      case 'accepted':
        statusIcon = Icons.check_circle;
        statusColor = Colors.green;
        break;
      case 'rejected':
        statusIcon = Icons.cancel;
        statusColor = Colors.red;
        break;
      default:
        statusIcon = Icons.info;
        statusColor = Colors.black;
    }

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
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                              '${appointment.firstName}.${appointment.lastName}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${appointment.age} ${S.of(context).years} | ${appointment.sexe}',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Color.fromRGBO(100, 235, 182, 1)),
                      const SizedBox(width: 5),
                      Text(
                        '${S.of(context).time}: ${appointment.selectedTime}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.calendar_month, color: Color.fromRGBO(100, 235, 182, 1)),
                      const SizedBox(width: 5),
                      Text(
                        '${S.of(context).day}: ${appointment.selectedDay}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        statusIcon,
                        color: statusColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        appointment.status.toUpperCase(),
                        style: TextStyle(fontSize: 16, color: statusColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (appointment.status == 'pending')
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Provider.of<AppointmentsProvider>(context, listen: false)
                                .updateAppointmentStatus(appointment, 'accepted',context);
                          },
                          icon: const Icon(Icons.check, color: Colors.white),
                          label: Text(S.of(context).accept, 
                          style:const  TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            Provider.of<AppointmentsProvider>(context, listen: false)
                                .updateAppointmentStatus(appointment, 'rejected',context);
                          },
                          icon: const Icon(Icons.close, color: Colors.white),
                          label: Text(S.of(context).reject,
                           style: const TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


