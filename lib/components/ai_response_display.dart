import 'package:flutter/material.dart';

class ResponseDisplay extends StatelessWidget {
  final String response;

  const ResponseDisplay({required this.response, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SelectableText(
        response,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
