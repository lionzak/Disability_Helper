import 'package:disability_helper/components/emergency_popup.dart';
import 'package:flutter/material.dart';

String GEMINI_API_KEY = "AIzaSyBachxfHDicT6pDrLh3XG0kgworip4TeLI";

List<Map<String, dynamic>> foodList = [
  // Vegetables
  {'name': 'Carrots', 'imagePath': 'images/carrot.webp'},
  {'name': 'Tomatoes', 'imagePath': 'images/tomato.webp'},
  {'name': 'Potatoes', 'imagePath': 'images/potato.webp'},
  {'name': 'Cucumbers', 'imagePath': 'images/cucumber.webp'},

  // Fruits
  {'name': 'Apples', 'imagePath': 'images/apple.webp'},
  {'name': 'Bananas', 'imagePath': 'images/banana.webp'},
  {'name': 'Oranges', 'imagePath': 'images/orange.webp'},
  {'name': 'Grapes', 'imagePath': 'images/grape.webp'},
  {'name': 'Strawberries', 'imagePath': 'images/strawberry.webp'},
  {'name': 'Mangoes', 'imagePath': 'images/mango.webp'},

  // Nuts
  {'name': 'Almonds', 'imagePath': 'images/almond.webp'},
  {'name': 'Cashews', 'imagePath': 'images/cashew.webp'},
  {'name': 'Peanuts', 'imagePath': 'images/peanut.webp'},
  {'name': 'Pistachios', 'imagePath': 'images/pistachio.webp'},
];

const TEXT_COLOR = Colors.white;
const TEXT_COLOR2 = Color(0Xff6D9773);
const BG_COLOR = Color(0xFF0C3B2E);
const BTN_COLOR = Color(0xFFFFBA00);
const SECONDARY_COLOR = Color(0xfffb46617);

var FLOATING_BUTTON = Builder(
  builder: (BuildContext context) {
    return FloatingActionButton(
      backgroundColor: BTN_COLOR,
      onPressed: () async {
        await emergencyPopup(context);
      },
      child: const Icon(
        Icons.sos_sharp,
        size: 30,
      ),
    );
  },
);
