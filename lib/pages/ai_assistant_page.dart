import 'package:disability_helper/components/emergency_popup.dart';
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
    color: Colors.blue,
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
  void initState() {
    _speech = stt.SpeechToText();

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
      // Add your completion logic here
    });

    messageController.addListener(() {
      setState(() {
        messageIcon = messageController.text.isEmpty
            ? const Icon(
                Icons.mic,
                size: 50,
                color: Colors.blue,
              )
            : const Icon(
                Icons.send,
                size: 50,
                color: Colors.blue,
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
              decoration: const BoxDecoration(color: Color(0XFFb3dfff)),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
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
                        color: Colors.blue,
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
                            fontSize: 22, fontWeight: FontWeight.bold),
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
                        child: TextFormField(
                          controller: messageController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.blue,
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2.0)),
                            label: Text("Ask Anything",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: messageIcon.icon == Icons.mic
                          ? onMicPressed
                          : onSendPressed,
                      icon: messageIcon,
                      iconSize: 50,
                      color: Colors.blue,
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    response,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ));
  }

  onMicPressed() async {
    flutterTts.stop();
    await _startListening();
    _speech.statusListener = (status) async {
      if (status == "done" && _text.isNotEmpty) {
        await sendToGemini(_text); // Call asynchronously without awaiting
      }
    };
  }

  onSendPressed() async {
    flutterTts.stop();
    await sendToGemini(messageController.text);
    messageController.clear();
    _text = "";
  }

  sendToGemini(String question) async {
    if (await isDataExists("Health", boxHealth)) {
      Health health = boxHealth.get("Health");
      String allergies = health.allergies!
          .where((allergy) => allergy.isNotEmpty)
          .map((allergy) => '$allergy allergy')
          .join(", ");
      String diseases = health.diseases!.join(", ");
      response = await geminiService.sendToGemini(
          "Someone that has ${diseases.isNotEmpty ? diseases : "No diseases"} and has ${allergies.isNotEmpty ? allergies : "No allergies"} who is ${health.age} yrs old and he/she is a ${health.isMale ? "male" : "female"} person ask's you : $question what will you respond ? (Maximum 200 letters)",
          context);
      speak(response);
      setState(() {});
    } else {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                  title: Text(
                "Please Add Health Details In Settings!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )));
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
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(
          localeId: _getLocaleId(selectedLanguage),
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
          });
    }
  }
}
