import 'package:disability_helper/components/grid_item.dart';
import 'package:disability_helper/pages/ai_assistant_page.dart';
import 'package:disability_helper/pages/color_identification_page.dart';
import 'package:disability_helper/pages/food_nutrients_page.dart';
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
        image: "images/textToSpeechIcon.webp",
        imgWidth: 200,
        imgHeight: 100,
        spaceBetween: 10,
      ),
      GridItem(
        page: SpeechToText(),
        title: "Speech To Text",
        image: "images/microphone 2.webp",
        imgWidth: 100,
        imgHeight: 100,
        spaceBetween: 10,
      ),
      GridItem(
        page: MedicineReminderPage(),
        title: "Medicine Reminder",
        image: "images/medicine 1.webp",
        imgWidth: 120,
        imgHeight: 120,
        spaceBetween: 5,
      ),
      GridItem(
        page: FoodNutrientsPage(),
        title: "Food Nutrients",
        image: "images/grocery 1.webp",
        imgWidth: 110,
        imgHeight: 120,
        spaceBetween: 5,
        isNutrients: true,
      ),
      GridItem(
        page: ColorIdentificationPage(),
        title: "Color Identification",
        image: "images/color_wheel.webp",
        imgWidth: 120,
        imgHeight: 120,
        spaceBetween: 5,
      ),
      GridItem(
        page: AiAssistantPage(),
        title: "AI Assistant",
        image: "images/ai logo 2.webp",
        imgWidth: 120,
        imgHeight: 120,
        spaceBetween: 5,
      ),
    ]);
  }
}
