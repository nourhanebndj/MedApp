import 'package:flutter/material.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/model/Demande_des_medicament_model.dart';
import 'package:mediloc/provider/demande_medicament_provider.dart';
import 'package:provider/provider.dart';

class DemandeMedicamentList extends StatefulWidget {
  final String pharmacieId;
  final String selectedLanguage;

  const DemandeMedicamentList({
    Key? key,
    required this.pharmacieId,
    required this.selectedLanguage,
  }) : super(key: key);

  @override
  _DemandeMedicamentListState createState() => _DemandeMedicamentListState();
}

class _DemandeMedicamentListState extends State<DemandeMedicamentList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DemandeMedicamentProvider>(context, listen: false)
          .loadDemandesMedicament(widget.pharmacieId);
    });
  }

  Future<void> _refreshDemandes() async {
    await Provider.of<DemandeMedicamentProvider>(context, listen: false)
        .loadDemandesMedicament(widget.pharmacieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myMedicationRequests),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: widget.selectedLanguage == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Consumer<DemandeMedicamentProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _refreshDemandes,
                child: ListView.builder(
                  itemCount: provider.demandesMedicament.length,
                  itemBuilder: (context, index) {
                    final demande = provider.demandesMedicament[index];
                    return DemandeMedicamentCard(demande: demande);
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class DemandeMedicamentCard extends StatefulWidget {
  final Demande_Disponibilite demande;

  const DemandeMedicamentCard({Key? key, required this.demande})
      : super(key: key);

  @override
  _DemandeMedicamentCardState createState() => _DemandeMedicamentCardState();
}

class _DemandeMedicamentCardState extends State<DemandeMedicamentCard> {
  bool _buttonsDisabled = false; // Variable pour désactiver les boutons après sélection
  bool _noteAdded = false; // Variable pour indiquer si la note a été ajoutée

  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController =
        TextEditingController(text: widget.demande.note ?? '');
    _noteAdded = widget.demande.note != null && widget.demande.note!.isNotEmpty;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String? _validateNoteInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a note';
    }
    return null; // Retourne null si la validation réussit
  }

  @override
  Widget build(BuildContext context) {
    IconData statusIcon;
    Color statusColor;
    switch (widget.demande.statut) {
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'lib/assets/images/pharmacien.png',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.demande.firstName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${S.of(context).age}: ${widget.demande.age}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${S.of(context).medicationList}: ${widget.demande.text}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Icon(
                          statusIcon,
                          color: statusColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.demande.statut.toUpperCase(),
                          style: TextStyle(fontSize: 16, color: statusColor),
                        ),
                      ],
                    ),
                    if (widget.demande.statut == 'rejected' || widget.demande.statut == 'accepted') ...[
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _noteController,
                        enabled: !_noteAdded,
                        onChanged: (text) {
                          setState(() {
                            _buttonsDisabled = text.isEmpty;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: S.of(context).note,
                          border: const OutlineInputBorder(),
                        ),
                        validator: _validateNoteInput,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _buttonsDisabled ||
                            _noteAdded ||
                            _validateNoteInput(_noteController.text) != null
                            ? null
                            : () {
                          String status = widget.demande.statut == 'rejected' ? 'rejected' : 'accepted';
                          Provider.of<DemandeMedicamentProvider>(
                            context,
                            listen: false,
                          ).updateDemandeMedicamentStatus(
                            widget.demande,
                            status,
                            note: _noteController.text,
                          );
                          setState(() {
                            _buttonsDisabled = true;
                            _noteAdded = true;
                          });
                        },
                        child: Text(widget.demande.statut == 'rejected' ? S.of(context).saveNote : S.of(context).accept),
                      ),
                    ],
                    const SizedBox(height: 10),
                    if (!(_buttonsDisabled ||
                        widget.demande.statut == 'accepted' ||
                        widget.demande.statut == 'rejected')) // Vérifier si les boutons ne sont pas déjà désactivés ou si un statut a été choisi
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Provider.of<DemandeMedicamentProvider>(
                                      context,
                                      listen: false)
                                  .updateDemandeMedicamentStatus(
                                  widget.demande, 'accepted');
                              setState(() {
                                _buttonsDisabled =
                                true; // Désactive les boutons après avoir choisi le statut
                              });
                            },
                            icon: const Icon(Icons.check, color: Colors.white),
                            label: Text(S.of(context).accept,
                                style: const TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () {
                              Provider.of<DemandeMedicamentProvider>(
                                      context,
                                      listen: false)
                                  .updateDemandeMedicamentStatus(
                                widget.demande,
                                'rejected',
                                note: _noteController.text,
                              );
                              setState(() {
                                _buttonsDisabled =
                                true; // Désactive les boutons après avoir choisi le statut
                              });
                            },
                            icon: const Icon(Icons.close, color: Colors.white),
                            label: Text(S.of(context).reject,
                                style: const TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
