
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/main.dart';

class ForgotPassword extends StatefulWidget {
  final String selectedLanguage;
  const ForgotPassword({Key? key, required this.selectedLanguage}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = "";
  TextEditingController mailcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:  Text("Password Reset Email has been sent !",
        style: TextStyle(fontSize: 20.0),
      )));
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "No user found for that email.",
          style: TextStyle(fontSize: 20.0),
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Directionality(
        textDirection: widget.selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          children: [
            SizedBox(

              height:300,
              child: Image.asset(
                'lib/assets/images/MediApp.png',
                width: 200,
                height: 200,
              ),
            ),
            Text(
              S.of(context).Forgot_your_password,
              style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
           const  SizedBox(
              height: 10.0,
            ),
             Text(
              S.of(context).Enter_your_mail,
              style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: Form(
                    key: _formkey,
                    child: Padding(
                      padding:const  EdgeInsets.only(left: 10.0),
                      child: ListView(
                        children: [
                          Container(
                            padding:const  EdgeInsets.only(left: 10.0),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color.fromARGB(179, 0, 0, 0), width: 2.0),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Email';
                                }
                                return null;
                              },
                              controller: mailcontroller,
                              style:const  TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                              decoration: InputDecoration(
                                  hintText:S.of(context).Email,
                                  hintStyle: const TextStyle(
                                      fontSize: 18.0, color: Color.fromARGB(255, 0, 0, 0)),
                                   prefixIcon: const Icon(
                                    Icons.mail,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    size: 30.0,
                                  ),
                                  border: InputBorder.none),
                            ),
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              if(_formkey.currentState!.validate()){
                                setState(() {
                                  email=mailcontroller.text;
                                });
                                resetPassword();
                              }
                            },
                            child: Container(
                              width: 100,
                              padding:const  EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 95, 217, 164),
                                  borderRadius: BorderRadius.circular(25)),
                              child:Center(
                                child: Text(
                                  S.of(context).Send_Email,
                                  style:const  TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               Text(
                                S.of(context).Dont_have_an_account,
                                style: const TextStyle(
                                    fontSize: 18.0, color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>const MyApp()));
                                },
                                child:  Text(
                                 S.of(context).Create ,
                                  style:const TextStyle(
                                      color: Color.fromARGB(223, 97, 236, 127),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}