import 'package:disability_helper/components/build_button.dart';
import 'package:disability_helper/consts.dart';
import 'package:flutter/services.dart';
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
    try {
      bool available = await _speech.initialize();
      if (available) {
        _speech.listen(
          localeId: _getLocaleId(selectedLanguage),
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Speech recognition not available")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _stopListening() async {
    try {
      await _speech.stop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
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

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    _speech.cancel();
    super.dispose();
  }

  Widget buildDropdown() {
    return DropdownButton<String>(
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
        });
      },
      items: languages.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speech to Text"),
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    buildDropdown(),
                    const Spacer(),
                    if (_text.isNotEmpty &&
                        _text != "Press the button to start speaking" &&
                        _text != "Listening...")
                      IconButton(
                        icon: const Icon(
                          Icons.copy,
                          color: BTN_COLOR,
                          size: 28,
                        ),
                        onPressed: _copyToClipboard,
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                SelectableText(
                  _text,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: null,
                ),
                const SizedBox(height: 20),
                buildButton(
                    text: "Start Listening",
                    onPress: _startListening,
                    color: Colors.lightBlue,
                    context: context),
                const SizedBox(height: 10),
                buildButton(
                    text: "Stop Listening",
                    onPress: _stopListening,
                    color: Colors.red.shade500,
                    context: context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
