import 'package:disability_helper/consts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'dart:io';

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

  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "";

  double pitch = 1;
  double volume = 0.8;
  double speed = 0.8; // Default to the middle of the range
  bool speaking = false;

  SliderThemeData? sliderThemeData;

  @override
  void didChangeDependencies() {
    sliderThemeData = SliderTheme.of(context).copyWith(
      activeTrackColor: BTN_COLOR,
      inactiveTrackColor: Colors.white,
      thumbColor: BTN_COLOR,
      overlayColor: Colors.red.withOpacity(0.2),
    );
    super.didChangeDependencies();
  }

  @override
  void initState() {
    flutterTts.setCompletionHandler(() {
      setState(() {
        speaking = false;
      });
    });
    selectedLanguage = 'EN';
    flutterTts.setLanguage(_getLocaleId(selectedLanguage));
    flutterTts.setPitch(pitch);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['doc', 'docx', 'txt'], // TODO: Add PDF support
    );

    if (result != null) {
      selectedFile = File(result.files.single.path!);
      selectedFileName = result.files.single.name;
      setState(() {});
    }
  }

  Future<void> processAndSpeakFile() async {
    if (selectedFile != null) {
      String text = await selectedFile!.readAsString();
      speak(text);
    }
  }

  Future<void> speak(String text) async {
    String localeId = _getLocaleId(selectedLanguage);
    bool isLanguageAvailable =
        await flutterTts.isLanguageAvailable(localeId) ?? false;

    if (isLanguageAvailable) {
      if (!speaking) {
        setState(() => speaking = true);
        await flutterTts.setLanguage(localeId);
        await flutterTts.speak(text);
      }
    } else {
      _showLanguageNotSupportedDialog();
    }
  }

  void _showLanguageNotSupportedDialog() {
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

  String _getLocaleId(String language) {
    switch (language) {
      case 'EN':
        return 'en-US';
      case 'AR':
        return 'ar';
      default:
        return 'en-US';
    }
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occurred while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();

    scannedText = recognisedText.blocks
        .map((block) => block.lines.map((line) => line.text).join('\n'))
        .join('\n');

    if (scannedText.isEmpty) {
      scannedText = "No text found";
    }
    textScanning = false;
    setState(() {});
  }

  Widget buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
    int? divisions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        SliderTheme(
          data: sliderThemeData!,
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget buildButton() {
    return GestureDetector(
      onTap: () async {
        String? textToSpeak;
        if (scannedText.isNotEmpty) {
          textToSpeak = scannedText;
        } else if (selectedFile != null) {
          String fileExtension =
              path.extension(selectedFile!.path).toLowerCase();
          if (fileExtension == '.doc' || fileExtension == '.docx') {
            final bytes = await selectedFile!.readAsBytes();
            textToSpeak = docxToText(bytes);
          } else {
            textToSpeak = await selectedFile!.readAsString();
          }
        } else if (_textController.text.isNotEmpty) {
          textToSpeak = _textController.text;
        }

        if (textToSpeak != null && textToSpeak.isNotEmpty) {
          await speak(textToSpeak);
        } else {
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              title: Text("Please Enter Text Or Select A File"),
            ),
          );
        }
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: BTN_COLOR,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            "Start Text To Speech",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Text To Speech"),
        centerTitle: true,
        backgroundColor: BTN_COLOR,
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: BG_COLOR),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        value: selectedLanguage,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 35,
                        elevation: 16,
                        style: const TextStyle(color: BTN_COLOR, fontSize: 20),
                        underline: Container(
                          height: 2,
                          color: SECONDARY_COLOR,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLanguage = newValue!;
                            flutterTts.setLanguage(_getLocaleId(newValue));
                          });
                        },
                        items: languages.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      if (speaking)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              speaking = false;
                              flutterTts.stop();
                            });
                          },
                          icon: const Icon(
                            Icons.pause,
                            size: 30,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Text..",
                      labelStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (selectedFile != null)
                    Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedFile = null;
                                  selectedFileName = null;
                                  scannedText = "";
                                  flutterTts.stop();
                                });
                              },
                              icon: const Icon(Icons.close),
                              color: Colors.redAccent,
                              iconSize: 35,
                            ),
                            Text(
                              "Selected File: $selectedFileName",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  GestureDetector(
                    onTap: _pickFile,
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: BTN_COLOR,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Select A File",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (imageFile != null) buildImagePreview(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildImagePickerButton(
                        label: "Gallery",
                        icon: Icons.image,
                        onPressed: () => getImage(ImageSource.gallery),
                      ),
                      buildImagePickerButton(
                        label: "Camera",
                        icon: Icons.camera_alt,
                        onPressed: () => getImage(ImageSource.camera),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Divider(color: Colors.white, thickness: 2),
                  buildButton(),
                  const SizedBox(height: 20),
                  buildAudioControl(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImagePickerButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.grey[400],
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 30),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAudioControl() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.5,
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade800,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Control Audio",
              style: TextStyle(
                letterSpacing: 2,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Divider(color: Colors.white, thickness: 1),
            const SizedBox(height: 20),
            buildSlider(
              label: "Pitch",
              value: pitch,
              min: 0.5,
              max: 2,
              onChanged: (value) {
                setState(() {
                  pitch = value;
                  flutterTts.setPitch(pitch);
                });
              },
            ),
            buildSlider(
              label: "Volume",
              value: volume,
              min: 0.1,
              max: 1,
              onChanged: (value) {
                setState(() {
                  volume = value;
                  flutterTts.setVolume(volume);
                });
              },
            ),
            buildSlider(
              label: "Speed",
              value: speed,
              min: 0.1,
              max: 1.5,
              divisions: 14,
              onChanged: (value) {
                setState(() {
                  speed = value;
                  flutterTts.setSpeechRate(speed);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImagePreview() {
    return Column(
      children: [
        Divider(color: Colors.lightBlue[200], thickness: 2),
        Text(
          scannedText,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        Padding(  
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Image.file(File(imageFile!.path)),
              Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      imageFile = null;
                      scannedText = "";
                      flutterTts.stop();
                    });
                  },
                  child: const Icon(
                    Icons.close,
                    size: 35,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
