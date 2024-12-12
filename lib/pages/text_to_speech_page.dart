import 'dart:io';
import 'package:disability_helper/components/emergency_popup.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechPage extends StatefulWidget {
  const TextToSpeechPage({super.key});

  @override
  State<TextToSpeechPage> createState() => _TextToSpeechPageState();
}

class _TextToSpeechPageState extends State<TextToSpeechPage> {
  final TextEditingController _textController = TextEditingController();

  final FlutterTts flutterTts = FlutterTts();

  late String selectedLanguage;
  final List<String> languages = ['EN', 'AR'];

  File? selectedFile;
  String? selectedFileName;

  double pitch = 1;
  double volume = 0.8;

  @override
  void initState() {
    selectedLanguage = 'EN';
    flutterTts.setLanguage(_getLocaleId(selectedLanguage));
    flutterTts.setPitch(pitch);

    super.initState();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        //TODO make it support PDF
        allowedExtensions: ['doc', 'docx', 'txt']);

    if (result != null) {
      selectedFile = File(result.files.single.path!);
      selectedFileName = result.files.single.name;
      setState(() {});
    }
  }

  Future<void> processAndSpeakFile() async {
    String text = await selectedFile!.readAsString();
    speak(text);
  }

  speak(String text) async {
    String localeId = _getLocaleId(selectedLanguage);

    // Check if language is available
    bool isLanguageAvailable =
        await flutterTts.isLanguageAvailable(localeId) ?? false;

    if (isLanguageAvailable) {
      await flutterTts.setLanguage(localeId);
      await flutterTts.speak(text);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Language Not Supported"),
          content: const Text(
              "The selected language is not available on this device."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  String _getLocaleId(String language) {
    switch (language) {
      case 'EN':
        return 'en-US';
      case 'AR':
        return 'ar';
      // Add more language-locale pairs as needed
      default:
        return 'en-US'; // Default to English
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Text To Speech"),
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
        body: Stack(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: Color(0XFF98B9AB)),
          ),
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height /
                      4 // Constrain the height
                  ),
              child: IntrinsicHeight(
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 36, left: 36, right: 36),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            DropdownButton<String>(
                              value: selectedLanguage,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 28,
                              elevation: 16,
                              style: const TextStyle(
                                  color: Colors.deepPurple, fontSize: 20),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedLanguage = newValue!;
                                  flutterTts
                                      .setLanguage(_getLocaleId(newValue));
                                });
                              },
                              items: languages.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Enter Text",
                            labelStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        selectedFile != null
                            ? Column(children: [
                                Text(
                                  "Selected File: $selectedFileName",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ])
                            : Container(),
                        GestureDetector(
                          onTap: _pickFile,
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text("Select A File",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        buildButton(),
                        const SizedBox(
                          height: 70,
                        ),
                        Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3.5,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue.shade800,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Control Audio",
                                      style: TextStyle(
                                          letterSpacing: 2,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  const Divider(
                                    color: Colors.white,
                                    thickness: 1,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text("Pitch",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20)),
                                  Slider(
                                    value: pitch,
                                    min: 0.5,
                                    max: 2,
                                    onChanged: (double value) {
                                      setState(() {
                                        pitch = value;
                                        flutterTts.setPitch(pitch);
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text("Volume",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20)),
                                  Slider(
                                    value: volume,
                                    min: 0.1,
                                    max: 1,
                                    onChanged: (double value) {
                                      setState(() {
                                        volume = value;
                                        flutterTts.setVolume(volume);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]));
  }

  Widget buildButton() {
    return GestureDetector(
      onTap: () async {
        if (_textController.text.isNotEmpty) {
          await speak(_textController.text);
          return;
        } else if (selectedFile != null) {
          String fileExtension =
              path.extension(selectedFile!.path).toLowerCase();
          if (fileExtension == '.doc' || fileExtension == '.docx') {
            final bytes = await selectedFile!.readAsBytes();
            final text = docxToText(bytes);
            await speak(text);
            return;
          }
          processAndSpeakFile();
        } else {
          showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                  title: Text("Please Enter Text Or Select A File")));
        }
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
            child: Text("Start Text To Speech",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20))),
      ),
    );
  }
}
