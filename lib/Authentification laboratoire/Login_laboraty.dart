import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediloc/Authentification%20laboratoire/profillaboratory.dart';
import 'package:mediloc/Authentification%20laboratoire/signup_laboraty.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/AuthentificationMedecin/ForgetPassword.dart';

class Loginlaboraty extends StatefulWidget {
  final String selectedLanguage;

  const Loginlaboraty({Key? key, required this.selectedLanguage}) : super(key: key);

  @override
  State<Loginlaboraty> createState() => _LoginState();
}

class _LoginState extends State<Loginlaboraty> {
  String email = "", password = "", name = "";
  String  laboratoryId = "";

  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();


  userLogin() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: mailcontroller.text,
        password: passwordcontroller.text,
      );

      String uid = userCredential.user!.uid;
      try {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('laboratoire')
            .doc(uid)
            .get();
        if (documentSnapshot.exists) {
           laboratoryId = uid;
          List<dynamic> workDays = documentSnapshot['workDays'] ?? [];
          List<String> workDaysList =
              workDays.map<String>((e) => e.toString()).toList();
          String category = documentSnapshot['category'] ?? '';
          String startTime = documentSnapshot['startTime'] ?? 'Not set';
          String endTime = documentSnapshot['endTime'] ?? 'Not set';
          GeoPoint location = documentSnapshot.get('location');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Profillaboratory(
                selectedLanguage: widget.selectedLanguage,
                name: documentSnapshot['name'],
                email: documentSnapshot['email'],
                phone: documentSnapshot['phone'],
                categorylaboratoryModelList: [],
                selectedCategories: [],
                selectedCategory: category,
                workDays: workDaysList,
                startTime: startTime,
                endTime: endTime,
                 laboratoryId:  laboratoryId,
                 location:location,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "User data not found",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Failed to fetch user data: ${e.toString()}",
              style:const  TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Login error: ${e.message}",
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: widget.selectedLanguage == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                      Image.asset(
                  'lib/assets/images/MediApp.png',
                  width: 150,
                  height: 150,
                ),
                    Text(
                      S.of(context).Login,
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
              const SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0), 
                          width:1, 
                        ),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter E-mail';
                            }
                            return null;
                          },
                          controller: mailcontroller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: S.of(context).Email,
                            hintStyle: const TextStyle(
                            ),
                            prefixIcon: const Icon(
                              Icons.mail,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0), 
                          width:1, 
                        ),
                        ),
                        child: TextFormField(
                          controller: passwordcontroller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: S.of(context).Password,
                            hintStyle: const TextStyle(
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              size: 30.0,
                            ),
                          ),
                          obscureText: true,
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              email = mailcontroller.text;
                              password = passwordcontroller.text;
                            });
                          }
                          userLogin();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(100, 235, 182, 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              S.of(context).Login,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPassword(
                        selectedLanguage: widget.selectedLanguage,
                      ),
                    ),
                  );
                },
                child: Text(
                  S.of(context).Forgot_Password,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).Dont_have_an_account,
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Signuplaboraty(
                            selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      S.of(context).SignUp,
                      style: const TextStyle(
                        color: Color.fromRGBO(100, 235, 182, 1),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
