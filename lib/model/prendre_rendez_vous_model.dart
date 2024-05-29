class Appointment {
  final String userId;
  final String doctorId;
  final String firstName;
  final String lastName;
  final String sexe;
  final String age;
  final String selectedDay;
  final String selectedTime;

  String status;

  Appointment({
    required this.userId,
    required this.doctorId,
    required this.firstName,
    required this.lastName,
    required this.sexe,
    required this.age,
    required this.selectedDay,
    required this.selectedTime,
    required this.status,
  });
}
