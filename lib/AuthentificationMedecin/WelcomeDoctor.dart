import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mediloc/AuthentificationMedecin/logindoctor.dart';
import 'package:mediloc/AuthentificationMedecin/signupdoctor.dart';

import 'package:mediloc/generated/l10n.dart';

class WelcomemedecinPage extends StatelessWidget {
      final String selectedLanguage;
  const WelcomemedecinPage({
    Key? key, 
    required this.selectedLanguage
    }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Directionality(
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
                Column(
                  children: <Widget>[
                    Text(
                      S.of(context).Welcome_Doctor,
                      style:const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
        
                      ),
                      
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      S.of(context).Your_trusted_companion_for_efficient_and_intuitive_medical_practice,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15,
        
                    ),)
                  ],
                ),
                SizedBox(
                  height:320,
                  child:Lottie.asset(
                      'lib/assets/animation/WelcomDoctor.json',
                      fit:BoxFit.cover,
                      ),
                ),
        
                Column(
                  children: <Widget>[
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Login(selectedLanguage:selectedLanguage,)));
        
                      },
                      shape: RoundedRectangleBorder(
                        side:const  BorderSide(
                          color: Colors.black
                        ),
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text(
                        S.of(context).Login,
                        style:const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                        ),
                      ),
                    ),
                    // creating the signup button
                    const SizedBox(height:20),
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Signup(selectedLanguage: selectedLanguage)));
        
                      },
                      color:const Color.fromRGBO(100, 235, 182, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child:  Text(
                        S.of(context).SignUp,
                        style:const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                        ),
                      ),
                    )
        
                  ],
                )
        
        
        
              ],
            ),
          ),
        ),
      ),
    );
  }
}