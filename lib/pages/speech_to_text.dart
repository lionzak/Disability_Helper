import 'package:disability_helper/components/emergency_popup.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';

class SpeechToText extends StatefulWidget {
  const SpeechToText({super.key});

  @override
  State<SpeechToText> createState() => _SpeechToTextState();
}

class _SpeechToTextState extends State<SpeechToText> {
  late stt.SpeechToText _speech;
  String _text = "Press the button to start speaking";

  String selectedLanguage = 'EN';
  final List<String> languages = ['EN', 'AR'];

  @override
  void initState() {
    _speech = stt.SpeechToText();
    super.initState();
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      print(selectedLanguage);
      _speech.listen(
          localeId: _getLocaleId(selectedLanguage),
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
          });
    }
  }

  String _getLocaleId(String language) {
    switch (language) {
      case 'EN':
        return 'en-US';
      case 'AR':
        return 'ar-SA';
      // Add more language-locale pairs as needed
      default:
        return 'en-US'; // Default to English
    }
  }

  void _stopListening() async {
    await _speech.stop();
  }

  @override
  void dispose() {
    super.dispose();
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speech to Text"),
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
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: Color(0XFF98B9AB)),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                            // Here, you can implement language switching logic
                            // For example, using `context.setLocale()` from the `flutter_localizations` package
                          });
                        },
                        items: languages
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                      child: SelectableText(_text,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 20),
                  buildButton("Start Listening", true, _startListening),
                  const SizedBox(height: 10),
                  buildButton("Stop Listening", false, _stopListening)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildButton(String text, bool isListen, VoidCallback? onPress) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _text =
              isListen ? "Listening..." : "Press the button to start speaking";
        });
        onPress!();
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Text(text,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20))),
      ),
    );
  }
}
