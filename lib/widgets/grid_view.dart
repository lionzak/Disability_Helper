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
    final double screenWidth = MediaQuery.of(context).size.width;
    double factor = screenWidth > 600 ? 0 : -50;
    return GridView.count(crossAxisCount: 2, children: [
      GridItem(
        page: const TextToSpeechPage(),
        title: "Text To Speech",
        image: "images/textToSpeechIcon.webp",
        imgWidth: 250 + factor,
        imgHeight: 150 + factor,
        spaceBetween: 10,
      ),
      GridItem(
        page: const SpeechToText(),
        title: "Speech To Text",
        image: "images/microphone 2.webp",
        imgWidth: 150 + factor,
        imgHeight: 150 + factor,
        spaceBetween: 10,
      ),
      GridItem(
        page: const MedicineReminderPage(),
        title: "Medicine Reminder",
        image: "images/medicine 1.webp",
        imgWidth: 170 + factor,
        imgHeight: 170 + factor,
        spaceBetween: 5,
      ),
      GridItem(
        page: const FoodNutrientsPage(),
        title: "Food Nutrients",
        image: "images/grocery 1.webp",
        imgWidth: 160 + factor,
        imgHeight: 170 + factor,
        spaceBetween: 5,
        isNutrients: true,
      ),
      GridItem(
        page: const ColorIdentificationPage(),
        title: "Color Identification",
        image: "images/color_wheel.webp",
        imgWidth: 170 + factor,
        imgHeight: 170 + factor,
        spaceBetween: 5,
      ),
      GridItem(
        page: const AiAssistantPage(),
        title: "AI Assistant",
        image: "images/ai logo 2.webp",
        imgWidth: 170 + factor,
        imgHeight: 170 + factor,
        spaceBetween: 5,
      ),  
    ]);
  }
}
