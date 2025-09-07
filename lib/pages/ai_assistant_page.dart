import 'package:disability_helper/components/ai_input_field.dart';
import 'package:disability_helper/components/ai_response_display.dart';
import 'package:disability_helper/components/language_dropdown.dart';
import 'package:disability_helper/consts.dart';
import 'package:disability_helper/services/boxes.dart';
import 'package:disability_helper/services/data_checker.dart';
import 'package:disability_helper/services/gemini.dart';
import 'package:disability_helper/services/health.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AiAssistantPage extends StatefulWidget {
  const AiAssistantPage({super.key});

  @override
  State<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage> {
  TextEditingController messageController = TextEditingController();
  GeminiService geminiService = GeminiService();

  Icon messageIcon = const Icon(
    Icons.mic,
    size: 50,
    color: BTN_COLOR,
  );

  late stt.SpeechToText _speech;
  String _text = "";
  String response = "";
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  String selectedLanguage = 'EN';
  final List<String> languages = ['EN', 'AR'];

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

  @override
  void dispose() {
    messageController.dispose();
    _speech.stop();
    _speech.cancel();
    flutterTts.stop();
    super.dispose();
  }

  @override
  void initState() {
    _speech = stt.SpeechToText();

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });

    messageController.addListener(() {
      setState(() {
        messageIcon = messageController.text.isEmpty
            ? const Icon(
                Icons.mic,
                size: 50,
                color: BTN_COLOR,
              )
            : const Icon(
                Icons.send,
                size: 50,
                color: BTN_COLOR,
              );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("AI assistant"),
          centerTitle: true,
          backgroundColor: BTN_COLOR,
        ),
        floatingActionButton: FLOATING_BUTTON,
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(color: BG_COLOR),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        LanguageDropdown(
                          selectedLanguage: selectedLanguage,
                          languages: languages,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedLanguage = newValue!;
                              flutterTts.setLanguage(_getLocaleId(newValue));
                            });
                          },
                        ),
                        const Spacer(),
                        isSpeaking
                            ? IconButton(
                                onPressed: () {
                                  flutterTts.stop();
                                  setState(() {
                                    isSpeaking = false;
                                  });
                                },
                                icon: const Icon(
                                  Icons.pause,
                                  size: 50,
                                  color: Colors.red,
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "images/ai logo 2.webp",
                        width: 100,
                        height: 100,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        width: MediaQuery.of(context).size.width - 110,
                        height: 50,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "How I Can Help You Today ?",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  _text.isNotEmpty
                      ? Text(
                          _text,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InputField(
                            controller: messageController,
                            onMicPressed: onMicPressed,
                            onSendPressed: onSendPressed,
                            messageIcon: messageIcon,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                  ),
                  ResponseDisplay(response: response),
                ],
              ),
            )
          ],
        ));
  }

  onMicPressed() async {
    isSpeaking = false;
    response = "";
    flutterTts.stop();
    await _startListening();
    _speech.statusListener = (status) async {
      if (status == "done" && _text.isNotEmpty) {
        await sendToGemini(_text);
      }
    };
  }

  onSendPressed() async {
    isSpeaking = false;
    flutterTts.stop();
    _text = "";
    await sendToGemini(messageController.text);
    messageController.clear();
    setState(() {
      
    });
  }

  Future<void> sendToGemini(String question) async {
    try {
      if (await isDataExists("Health", boxHealth)) {
        Health health = boxHealth.get("Health");
        String allergies = health.allergies!
            .where((allergy) => allergy.isNotEmpty)
            .map((allergy) => '$allergy allergy')
            .join(", ");
            
        String diseases = health.diseases!.join(", ");
        response = await geminiService.sendToGemini(
          "Someone that has ${diseases.isNotEmpty ? diseases : "No diseases"} and has ${allergies.isNotEmpty ? allergies : "No allergies"} who is ${health.age} yrs old and he/she is a ${health.isMale ? "male" : "female"} person asks you: $question. What will you respond? (100 words max , answer in the language of the question)",
          context,
        );
        speak(response);
        setState(() {});
      } else {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text(
              "Please Add Health Details In Settings!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  speak(String text) async {
    String localeId = _getLocaleId(selectedLanguage);

    bool isLanguageAvailable =
        await flutterTts.isLanguageAvailable(localeId) ?? false;

    if (isLanguageAvailable && isSpeaking == false) {
      isSpeaking = true;
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

  Future<void> _startListening() async {
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
}
