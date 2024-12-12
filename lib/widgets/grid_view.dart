import 'package:disability_helper/components/grid_item.dart';
import 'package:disability_helper/pages/medicine_reminder_page.dart';
import 'package:disability_helper/pages/speech_to_text.dart';
import 'package:disability_helper/pages/text_to_speech_page.dart';
import 'package:flutter/material.dart';

class GridViewPage extends StatelessWidget {
  const GridViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(crossAxisCount: 2, children: const [
      GridItem(
        page: TextToSpeechPage(),
        title: "Text To Speech",
        image: "images/textToSpeechIcon.png",
        imgWidth: 200,
        imgHeight: 100,
        spaceBetween: 10,
      ),
      GridItem(
        page: SpeechToText(),
        title: "Speech To Text",
        image: "images/microphone.png",
        imgWidth: 100,
        imgHeight: 100,
        spaceBetween: 10,
      ),
      GridItem(
        page: MedicineReminderPage(),
        title: "Medicine Reminder",
        image: "images/medicine.png",
        imgWidth: 120,
        imgHeight: 120,
        spaceBetween: 5,
      ),
    ]);
  }
}
