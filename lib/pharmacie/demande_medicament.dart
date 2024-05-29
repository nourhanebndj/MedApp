  import 'dart:io';
  import 'package:flutter/material.dart';
  import 'package:google_ml_kit/google_ml_kit.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:dotted_border/dotted_border.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediloc/generated/l10n.dart';
  import 'package:mediloc/model/pharmacie_model.dart';
import 'package:slide_to_act/slide_to_act.dart';

  class MedicationRequestPage extends StatefulWidget {
    final PharmacieModel pharmacie;
      final String selectedLanguage;


    const MedicationRequestPage({Key? key, required this.pharmacie,required this.selectedLanguage})
        : super(key: key);

    @override
    _MedicationRequestPageState createState() => _MedicationRequestPageState();
  }

  class _MedicationRequestPageState extends State<MedicationRequestPage> {
    late TextEditingController _firstNameController;
    late TextEditingController _ageController;
    TextEditingController _textEditingController = TextEditingController();

    XFile? _imageFile;
    bool _uploadingImage = false;

    @override
    void initState() {
      super.initState();
      _firstNameController = TextEditingController();
      _ageController = TextEditingController();
      _textEditingController = TextEditingController();
    }

    @override
    void dispose() {
      _firstNameController.dispose();
      _ageController.dispose();
      _textEditingController.dispose();
      super.dispose();
    }

    Future<void> _submitRequest(BuildContext context) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("User not logged in");
        return;
      }

      if (_firstNameController.text.isEmpty ||
          _ageController.text.isEmpty ||
          _textEditingController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text(
                  "Please fill in all the fields and select an image."),
              actions: <Widget>[
                TextButton(
                  child: const Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }

      final now = DateTime.now();

      final medicationRequest = {
        'userId': user.uid,
        'firstName': _firstNameController.text,
        'Age': _ageController.text,
        'text': _textEditingController.text,
        'status': 'Pending',
        'pharmacieId': widget.pharmacie.id,
        'RequestDate': Timestamp.fromDate(now),
        'note':'',
      };

      try {
        await FirebaseFirestore.instance
            .collection('Demande_medicament')
            .add(medicationRequest);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const Text("Medication request submitted successfully."),
              actions: <Widget>[
                TextButton(
                  child: const Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        print("Error submitting medication request: $e");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Failed to submit medication request."),
              actions: <Widget>[
                TextButton(
                  child: const Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }

      _firstNameController.clear();
      _ageController.clear();
      setState(() {
        _imageFile = null;
      });
    }

    Future<void> _extractTextFromImage() async {
      if (_imageFile == null) return;

      final inputImage = InputImage.fromFile(File(_imageFile!.path));
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      String text = recognizedText.text;
      setState(() {
        _textEditingController.text = text;
        _uploadingImage = false;
      });

      textRecognizer.close();
    }

    Future<void> _pickImage() async {
      final imagePicker = ImagePicker();
      final imageFile = await imagePicker.pickImage(source: ImageSource.gallery);

      if (imageFile != null) {
        setState(() {
          _imageFile = imageFile;
          _uploadingImage = true;
        });
        _extractTextFromImage();
      }
    }

    Future<void> _takePhoto() async {
      final imagePicker = ImagePicker();
      final imageFile = await imagePicker.pickImage(source: ImageSource.camera);

      if (imageFile != null) {
        setState(() {
          _imageFile = imageFile;
          _uploadingImage = true;
        });
        _extractTextFromImage();
      }
    }

                   @override
                Widget build(BuildContext context) {
                 return Scaffold(
                      appBar: AppBar(
                      title: Text(S.of(context).Medication_Request),
                      centerTitle: true,
                            ),
      body:Directionality(
        textDirection: widget.selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                       child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                              child: Center(
                              child: Container(
                              margin: const EdgeInsets.all(2.0),
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                              const SizedBox(height: 20),
                               Text(
                              S.of(context).patientInformation,
                              style:const  TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                              children: [
                              TextFormField(
                              controller: _firstNameController,
                              decoration:  InputDecoration(
                                border:const  OutlineInputBorder(),
                              labelText: S.of(context).firstName,
                              prefixIcon:const  Icon(Icons.person),
                              ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              decoration:  InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText:S.of(context).age,
                              prefixIcon: const Icon(Icons.cake_outlined),
                              ),
                              ),
                              ],
                              ),
                              ),
                              const SizedBox(height: 24),
                              Column(
                              children: <Widget>[
                              GestureDetector(
                              onTap: _pickImage,
                              child: Padding(
                              padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10.0),
                              child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 4],
                              strokeCap: StrokeCap.round,
                              color: const Color.fromARGB(255, 71, 204, 142),
                              child: Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 202, 251, 224)
                              .withOpacity(.3),
                              borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              const Icon(
                              Icons.folder_open,
                              color: Color.fromARGB(255, 3, 3, 3),
                              size: 40,
                              ),
                              const SizedBox(height: 15),
                               Text(
                              S.of(context).Select_from_Gallery,
                              style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 83, 83, 83),
                              ),
                              ),
                              if (_uploadingImage)
                              const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: CircularProgressIndicator(),
                              ),
                              ElevatedButton.icon(
                              onPressed: _takePhoto,
                              icon: const Icon(Icons.camera_alt,color:Colors.black,),
                              label:  Text(
                                S.of(context).Take_a_Photo,
                              style:const TextStyle(
                              color:Colors.black
                              ),
                              ),
                              ),
                              ],
                              ),
                              ),
                              ),
                              ),
                              ),
                              const SizedBox(height: 10),
                              _imageFile != null
                              ? GestureDetector(
                              onTap: _pickImage,
                              child: Padding(
                              padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 20.0),
                              child: Image.file(File(_imageFile!.path)),
                              ),
                              )
                              : Container(),
                              Padding(
                              padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                              ),
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               Text(
                              S.of(context).List_of_Medicines,
                              style:const  TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                              decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                              ),
                              constraints: const BoxConstraints(
                              maxHeight: 300,
                              ),
                              child: SingleChildScrollView(
                              child: TextFormField(
                              controller: _textEditingController,
                              decoration:  InputDecoration(
                              hintText:S.of(context).List_of_Medicines,
                              contentPadding: const EdgeInsets.all(10),
                              border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              ),
                              ),
                              ),
                              ],
                              ),
                              ),
                              const SizedBox(height: 5),
                             Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: SlideAction(
                          borderRadius:20,
                          elevation: 0,
                          innerColor: Colors.white,
                          outerColor: const Color.fromRGBO(100, 235, 182, 1),
                          sliderButtonIcon: const Icon(
                            Icons.edit_document,
                            size: 20, 
                            color: Color.fromRGBO(100, 235, 182, 1),
                          ), 
                          text: S.of(context).Submit_Request,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16, // Ajustez la taille du texte selon vos besoins
                          ),
                          sliderRotate: false,
                          onSubmit: () => _submitRequest(context),
                        ),
                      )

                              ],
                              ),
                              ],
                              ),
                              ),
                              ),
                              ),
                            ),
                            );
                            }
                            }