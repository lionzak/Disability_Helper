import 'package:disability_helper/consts.dart';
import 'package:flutter/material.dart';

class SettingHeader extends StatelessWidget {
  final String title;
  const SettingHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      decoration: BoxDecoration(
          color: SECONDARY_COLOR, borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
        ),
      ),
    ));
  }
}
