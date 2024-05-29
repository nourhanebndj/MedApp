import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/pages/Allrequest.dart';
import 'package:mediloc/pages/all_appointement.dart';

class AccountPage extends StatelessWidget {
  final String selectedLanguage;
  const AccountPage({Key? key, required this.selectedLanguage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
       automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(S.of(context).Profile, style: const TextStyle(color: Colors.black, fontSize: 20)),
      ),
      body:Directionality(
        textDirection: selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: userId == null
            ?  Center(child: Text(S.of(context).No_user_logged_in))
            : FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('malade').doc(userId).get(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
        
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
        
                  if (!snapshot.hasData || snapshot.data!.data() == null) {
                    return const Center(child: Text('Document does not exist'));
                  }
                  var userDoc = snapshot.data!.data() as Map<String, dynamic>;
                  var username = userDoc['username'] ?? 'No username';
                  var phoneNumber = userDoc['phone'] ?? 'No phone number';
        
                  return SingleChildScrollView(
                    child: Column(
                      children: [
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 100,
          backgroundColor: Colors.transparent,
          child: Lottie.asset('lib/assets/animation/profil.json'),
        ),
        const SizedBox(height: 20),
        Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        Text(phoneNumber, style: const TextStyle(color: Color.fromARGB(255, 97, 97, 97), fontSize: 18)),
        const SizedBox(height: 20),
        _buildListTile(
          context,
          Icons.edit_document,
          S.of(context).My_All_Request,
          const Color.fromRGBO(100, 235, 182, 1),
          () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AllMedicationRequests(userId: userId,selectedLanguage: selectedLanguage,)));
          },
        ),
        _buildListTile(
          context,
          Icons.calendar_month,
          S.of(context).My_appointement,
          const Color.fromRGBO(100, 235, 182, 1),
          () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AllAppointments(userId: userId,selectedLanguage: selectedLanguage,)));
          },
        ),
        
        _buildListTile(
          context,
          Icons.exit_to_app,
          S.of(context).Logout,
          const Color.fromRGBO(100, 235, 182, 1),
          () {
            // Simuler une déconnexion
            FirebaseAuth.instance.signOut();
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
  Widget _buildListTile(BuildContext context, IconData icon, String title, Color iconColor, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
