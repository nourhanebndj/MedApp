import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mediloc/Authentification%20laboratoire/Login_laboraty.dart';
import 'package:mediloc/Authentification%20laboratoire/signup_laboraty.dart';
import 'package:mediloc/generated/l10n.dart';

class WelcomelaboratoirePage extends StatelessWidget {
  final String selectedLanguage;
  
  const WelcomelaboratoirePage({
    Key? key, 
    required this.selectedLanguage
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        S.of(context).Welcome_laboratory,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        S.of(context).Your_trusted_companion_for_finding_laboratories_efficiently_and_intuitively,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height:10,),
                SizedBox(
                  height: 300,
                  child: Lottie.asset(
                    'lib/assets/animation/laboratory.json',
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Loginlaboraty(selectedLanguage:selectedLanguage,)));
                        },
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          S.of(context).Login,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      MaterialButton(
                        minWidth: double.infinity,
                        height:50,
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Signuplaboraty(selectedLanguage: selectedLanguage)));
                        },
                        color: const Color.fromRGBO(100, 235, 182, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          S.of(context).SignUp,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
