import 'dart:io';
import 'package:disability_helper/components/emergency_popup.dart';
import 'package:disability_helper/consts.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class ColorIdentificationPage extends StatefulWidget {
  const ColorIdentificationPage({super.key});

  @override
  State<ColorIdentificationPage> createState() =>
      _ColorIdentificationPageState();
}

class _ColorIdentificationPageState extends State<ColorIdentificationPage> {
  String _geminiResponse = '';
  bool _isLoading = false; // Track loading state
  XFile? _imageFile;
  final TextEditingController _textController = TextEditingController();

  Future<DataPart> fileToPart(String path) async {
    final mimeType = lookupMimeType(path); // Automatically detects MIME type

    return DataPart(mimeType!, await File(path).readAsBytes());
  }

  String? getMimeType(String filePath) {
    return lookupMimeType(filePath); // Returns a MIME type like 'image/jpeg'
  }

  void pickImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    } else {
      return;
    }
  }

  Future<void> _sendToGemini() async {
    if (_imageFile != null && _textController.text.isNotEmpty) {
      setState(() {
        _isLoading = true; // Set loading to true when starting the request
        _geminiResponse = 'Loading...'; // Show loading message
      });

      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: GEMINI_API_KEY,
      );

      final GenerateContentResponse response;

      final image = await fileToPart(_imageFile!.path);
      response = await model.generateContent([
        Content.multi([
          TextPart(
              "Very short answer with no other details: what color of the ${_textController.text} in the image ?"),
          image
        ])
      ]);

      _geminiResponse = '';
      _geminiResponse += response.text!;
      setState(() {});

      {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                    title: Text(
                  "Please Enter Full Data",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )));
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFb3dfff),
      appBar: AppBar(
        title: const Text("Color Identifier"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await emergencyPopup(context);
        },
        child: const Icon(
          Icons.sos_sharp,
          size: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _imageFile != null
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 3.4,
                      child: Image.file(
                        File(_imageFile!.path),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      decoration: const BoxDecoration(color: Colors.grey),
                      height: MediaQuery.of(context).size.height / 3.4,
                    ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _textController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: _sendToGemini,
                          icon: const Icon(Icons.send)),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.lightBlue,
                      )),
                      label: const Text(
                          "Specify The Object In The Image You Want To Identify..."),
                      labelStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              buildButton(
                  text: "Pick Image",
                  onPress: () => pickImage(ImageSource.gallery),
                  icon: Icons.image),
              const SizedBox(
                height: 20,
              ),
              buildButton(
                  text: "Take Image",
                  onPress: () {
                    pickImage(ImageSource.camera);
                  },
                  icon: Icons.camera_alt),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3.2,
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Center(
                    child: Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const FittedBox(
                    child: Text(
                      "The Detected Color Is..",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    _geminiResponse,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold),
                  )
                ])),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(
      {String? text, VoidCallback? onPress, required IconData icon}) {
    return GestureDetector(
      onTap: () => onPress!(),
      child: Center(
        child: Container(
          height: 67,
          width: MediaQuery.of(context).size.width / 1.1,
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  children: [
                    Icon(
                      icon,
                      size: 30,
                    ),
                    Text(text!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
