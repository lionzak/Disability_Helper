import 'dart:io';
import 'package:disability_helper/components/image_preview.dart';
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
  bool _isLoading = false;
  XFile? _imageFile;
  final TextEditingController _textController = TextEditingController();

  Future<DataPart> fileToPart(String path) async {
    final mimeType = lookupMimeType(path);

    return DataPart(mimeType!, await File(path).readAsBytes());
  }

  String? getMimeType(String filePath) {
    return lookupMimeType(filePath); // Returns a MIME type like 'image/jpeg'
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void pickImage(ImageSource imageSource) async {
    try {
      final picker = ImagePicker();
      final pickedFile =
          await picker.pickImage(source: imageSource, imageQuality: 45);

      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No image selected")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _sendToGemini() async {
    if (_imageFile != null && _textController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _geminiResponse = 'Loading...';
      });

      try {
        final model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: GEMINI_API_KEY,
        );

        final image = await fileToPart(_imageFile!.path);

        final response = await model.generateContent([
          Content.multi([
            TextPart(
                "Very short answer with no other details: what color of the ${_textController.text} in the image?"),
            image,
          ])
        ]);

        setState(() {
          _geminiResponse = response.text ?? "No response received";
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _geminiResponse = "Error: $e";
          _isLoading = false;
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text(
            "Please Enter Full Data",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BG_COLOR,
      appBar: AppBar(
        title: const Text("Color Identifier"),
        centerTitle: true,
        backgroundColor: BTN_COLOR,
      ),
      floatingActionButton: FLOATING_BUTTON,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImagePreview(imageFile: _imageFile),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  controller: _textController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: _sendToGemini,
                          icon: const Icon(
                            Icons.send,
                            color: BTN_COLOR,
                          )),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.lightBlue,
                      )),
                      label: const Text(
                          "Specify The Object In The Image You Want To Identify..."),
                      labelStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
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
                  color: Colors.white,
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
                          color: Colors.black,
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
                        color: Colors.black,
                        fontSize: 40,
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
            color: BTN_COLOR,
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
