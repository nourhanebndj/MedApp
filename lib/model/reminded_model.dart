
class Reminder {
  String id;
  String note;
  String type;
  int interval;
  DateTime dateTime;

  Reminder({
    required this.id,
    required this.note,
    required this.type,
    required this.interval,
    required this.dateTime,
  });

  // Méthode pour créer une instance de Reminder à partir d'un Map
  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      note: map['note'],
      type: map['type'],
      interval: map['interval'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }

  // Méthode pour convertir un Reminder en un Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note': note,
      'type': type,
      'interval': interval,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
