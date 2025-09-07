import 'package:disability_helper/consts.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onMicPressed;
  final VoidCallback onSendPressed;
  final Icon messageIcon;

  const InputField({
    required this.controller,
    required this.onMicPressed,
    required this.onSendPressed,
    required this.messageIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              controller: controller,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                ),
                label: Text(
                  "Ask Anything..",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: messageIcon.icon == Icons.mic ? onMicPressed : onSendPressed,
          icon: messageIcon,
          iconSize: 50,
          color: BTN_COLOR,
        ),
      ],
    );
  }
}