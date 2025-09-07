import 'package:disability_helper/consts.dart';
import 'package:flutter/material.dart';

class LanguageDropdown extends StatelessWidget {
  final String selectedLanguage;
  final List<String> languages;
  final ValueChanged<String?> onChanged;

  const LanguageDropdown({
    required this.selectedLanguage,
    required this.languages,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
      onChanged: onChanged,
      items: languages.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}