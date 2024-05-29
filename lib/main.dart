import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mediloc/Authentification%20laboratoire/Welcome_laboratoire.dart';
import 'package:mediloc/AuthentificationMedecin/WelcomeDoctor.dart';
import 'package:mediloc/Services/firebaseservice.dart';
import 'package:mediloc/Services/notification_service.dart';
import 'package:mediloc/authentification%20pharmacie/welcomepharmacie.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/pages/splach.dart';
import 'package:mediloc/provider/category_laboratory_provider.dart';
import 'package:mediloc/provider/demande_medicament_provider.dart';
import 'package:mediloc/provider/laboratoire_provider.dart';
import 'package:mediloc/provider/myprovider.dart';
import 'package:mediloc/provider/myprovider_doctor.dart';
import 'package:mediloc/provider/prendre_rendez_vous_provider.dart';
import 'package:provider/provider.dart';
import 'user/phone.dart';
import 'package:mediloc/provider/myproviderpharmacie.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotification.init();
  await Firebase.initializeApp();
    await FirebaseService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Myprovider()),
        ChangeNotifierProvider(create: (context) => AppointmentsProvider()),
        ChangeNotifierProvider(create: (context) => DoctorProvider()),
        ChangeNotifierProvider(create: (context) => PharmacieProvider()),
        ChangeNotifierProvider(create:(context) => DemandeMedicamentProvider()),
        ChangeNotifierProvider(create: (_)=>Myproviderlaboratory()),
        ChangeNotifierProvider(create: (context)=>LaboratoireProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        home: SplashScreen(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _selectedLanguage = 'en'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
        actions: [
          DropdownButton<String>(
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedLanguage = newValue;
                  final locale = Locale(newValue);
                  S.load(locale);
                });
              }
            },
            value: _selectedLanguage,
            items: <String>['ar', 'fr', 'en'].map<DropdownMenuItem<String>>((String value) {
              String languageName = '';
              switch (value) {
                case 'ar':
                  languageName = 'العربية';
                  break;
                case 'fr':
                  languageName = 'Fr';
                  break;
                case 'en':
                  languageName = 'En';
                  break;
                default:
                  languageName = value;
              }
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    Image.asset(
                      'lib/assets/flags/$value.png',
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(languageName),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: Directionality(
        textDirection: _selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assets/images/MediApp.png',
                  width: 300,
                  height: 300,
                ),
                const SizedBox(height: 2),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: S.of(context).findyourquicklyyourdoctor,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 99, 99, 99),
                          ),
                        ),
                        TextSpan(
                          text: ' ${S.of(context).nearyour}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (ModalRoute.of(context)?.isCurrent ?? false) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WelcomemedecinPage(selectedLanguage:_selectedLanguage,)),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(100, 235, 182, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          shadowColor: Colors.grey,
                        ),
                        icon: const Icon(
                          Icons.local_hospital,
                          size: 20,
                          color: Colors.white,
                        ),
                        label: Text(
                          S.of(context).Areyouadoctor,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      flex: 1,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (ModalRoute.of(context)?.isCurrent ?? false) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyPhone(selectedLanguage: _selectedLanguage),
                                  ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(100, 235, 182, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(
                          Icons.person,
                          size: 20,
                          color: Colors.white,
                        ),
                        label: Text(
                          S.of(context).Areyouauser,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height:10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (ModalRoute.of(context)?.isCurrent ?? false) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WelcomePharmaciePage(selectedLanguage:_selectedLanguage,)),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(100, 235, 182, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          shadowColor: Colors.grey,
                        ),
                        icon: const Icon(
                          Icons.local_hospital,
                          size: 20,
                          color: Colors.white,
                        ),
                        label: Text(
                          S.of(context).Areyouapharmacist,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      flex: 1,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (ModalRoute.of(context)?.isCurrent ?? false) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WelcomelaboratoirePage(selectedLanguage: _selectedLanguage),
                                  ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(100, 235, 182, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(
                          Icons.biotech_sharp,
                          size: 20,
                          color: Colors.white,
                        ),
                        label: Text(
                          S.of(context).Areyoulaboraty,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
