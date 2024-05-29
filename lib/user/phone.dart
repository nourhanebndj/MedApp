import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/pages/Home.dart';
import 'package:mediloc/user/verificationcode.dart';

class MyPhone extends StatefulWidget {
  final String selectedLanguage;
  const MyPhone({Key? key, required this.selectedLanguage}) : super(key: key);

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String _verificationId = '';
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

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
                  color:  Color.fromRGBO(100, 235, 182, 1), 
                  borderRadius:  BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height:250,
                     child: Lottie.asset(
                      'lib/assets/images/verificationcode.json',
                      fit:BoxFit.cover,
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
                        padding: const EdgeInsets.symmetric(horizontal:20),
                        height: MediaQuery.of(context).size.height / 1.8,
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Directionality(
                          textDirection: widget.selectedLanguage == 'ar'
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: Container(
                            alignment: Alignment.center,
                            child: SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      S.of(context).registration,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    TextFormField(
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.person),
                                        labelText: S.of(context).username,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your username';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: _phoneController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.phone),
                                        labelText: S.of(context).phone,
                                        hintText: '+213(000000000)',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your phone number';
                                        } else if (!isValidPhoneNumber(value)) {
                                          return 'Phone number is incorrect';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 45,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!.validate()) {
                                            await _requestLocationService(
                                                context, widget.selectedLanguage);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromRGBO(100, 235, 182, 1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        child: _isLoading
                                            ? const CircularProgressIndicator()
                                            : Text(
                                                S.of(context).Send_Verification_Code,
                                                style: const TextStyle(color: Colors.white),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
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

  bool isValidPhoneNumber(String input) {
    final RegExp phoneRegex = RegExp(r'^\+?213?[0-9]{9}$');
    return phoneRegex.hasMatch(input);
  }

  Future<void> _verifyPhoneNumber(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: _phoneController.text.toString(),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(
                selectedLanguage: widget.selectedLanguage,
              ),
            ),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
          setState(() {
            _isLoading = false;
          });
        },
        codeSent: (String verificationId, [int? forceResendingToken]) async {
          _verificationId = verificationId;
          setState(() {
            _isLoading = false;
          });
          // Navigate to code verification screen with phone and username
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MyVerify(
                verificationId: _verificationId,
                phone: _phoneController.text,
                username: _usernameController.text,
                selectedLanguage: widget.selectedLanguage,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Auto retrieval timeout: $verificationId');
        },
      );
    } catch (e) {
      print('Error verifying phone number: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _requestLocationService(
      BuildContext context, String selectedLanguage) async {
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //Boite de dialogue pour faire la permission de localisation
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.red,
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Please enable location services to use this app.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      );
    } else {
      await _verifyPhoneNumber(context);
    }
  }
}
