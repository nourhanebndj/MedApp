import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/pages/Home.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class MyVerify extends StatefulWidget {
  final String verificationId;
  final String phone;
  final String username;
  final String selectedLanguage;

  MyVerify({
    Key? key,
    required this.selectedLanguage,
    required this.verificationId,
    required this.phone,
    required this.username,
  }) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  final TextEditingController _optController = TextEditingController();
  Timer? _timer;
  int _start = 30;  // Délai de 30 secondes pour le renvoi du code

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _verifyCode(BuildContext context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _optController.text.trim(),
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        String userId = userCredential.user!.uid;
        Position position = await _getCurrentLocation();
        await _addUserIfNotExists(userId, position);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home(selectedLanguage: widget.selectedLanguage)),
        );
      }
    } catch (e) {
      print('Error verifying code: $e');
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _addUserIfNotExists(String userId, Position position) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('malade').doc(userId).get();

    if (!userDoc.exists) {
      await FirebaseFirestore.instance.collection('malade').doc(userId).set({
        'username': widget.username,
        'phone': widget.phone,
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
    } else {
      print("User already exists in Firestore.");
    }
  }

  void resendCode() {
  print("Resending code...");
  setState(() {
    _start = 30;
    startTimer();
  });

  String phoneNumber = widget.phone;

  FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      print('Verification failed: $e');
    },
    codeSent: (String verificationId, int? resendToken) {},
    codeAutoRetrievalTimeout: (String verificationId) {},
    timeout: const Duration(seconds: 60),
    forceResendingToken: 0,
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(100, 235, 182, 1),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 250,
                      child: Lottie.asset(
                        'lib/assets/images/verificationcode.json',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: MediaQuery.of(context).size.height / 1.8,
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Directionality(
                          textDirection: widget.selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    S.of(context).Verification_code,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  PinCodeTextField(
                                    controller: _optController,
                                    appContext: context,
                                    length: 6,
                                    keyboardType: TextInputType.number,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 50,
                                      fieldWidth: 40,
                                      activeFillColor: Colors.white,
                                      inactiveFillColor: Colors.transparent,
                                    ),
                                    cursorColor: Colors.black,
                                    animationDuration: const Duration(milliseconds: 300),
                                    enableActiveFill: true,
                                    boxShadows: const [
                                      BoxShadow(
                                        offset: Offset(0, 1),
                                        color: Colors.black12,
                                        blurRadius: 10,
                                      )
                                    ],
                                    onCompleted: (v) {
                                      debugPrint("Completed");
                                      _verifyCode(context);
                                    },
                                    onChanged: (value) {},
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(100, 235, 182, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      await _verifyCode(context);
                                    },
                                    child: Text(
                                      S.of(context).Verify_Phone_Number,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height:10,),
                                   Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded( 
                                        child: Text(
                                          "Resend code in $_start sec",
                                          textAlign: TextAlign.center, 
                                          style: TextStyle(
                                            color: _start == 0 ? const Color.fromARGB(255, 243, 33, 33) : Colors.grey,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: _start == 0 ? resendCode : null,
                                        child: Text(
                                          S.of(context).Resend_code,
                                          style: TextStyle(
                                            color: _start == 0 ? const Color.fromRGBO(100, 235, 182, 1) : Colors.grey,
                                            decoration: _start == 0 ? TextDecoration.underline : TextDecoration.none,
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
