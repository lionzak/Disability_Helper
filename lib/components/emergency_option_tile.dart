import 'package:disability_helper/consts.dart';
import 'package:flutter/material.dart';

class EmergencyOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const EmergencyOptionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: BTN_COLOR,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor,
          size: 35,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: TEXT_COLOR,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        onTap: onTap,
      ),
    );
  }
}