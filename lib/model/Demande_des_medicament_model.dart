
class Demande_Disponibilite {
  final String userId;
  final String pharmacieId;
  final String firstName;
  final String age;
  final String text;
   String statut;
   String? note;

  Demande_Disponibilite({
    required this.userId,
    required this.pharmacieId,
    required this.firstName,
    required this.age,
    required this.text,
    required this.statut,
    this.note,
  });
}
