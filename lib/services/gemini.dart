import 'dart:io';
import 'package:disability_helper/consts.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class GeminiService{
  
Future<String> sendToGemini(
    String text, BuildContext context, {XFile? imageFile}) async {
  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: GEMINI_API_KEY,
  );

  var prompt = text;
  final GenerateContentResponse response;

  if (imageFile != null) {
    final image = await fileToPart(imageFile.path);
    response = await model.generateContent([
      Content.multi([TextPart(prompt), image])
    ]);
  } else {
    response = await model.generateContent([Content.text(prompt)]);
  }
  return response.text!;

}

Future<DataPart> fileToPart(String path) async {
  final mimeType = lookupMimeType(path); // Automatically detects MIME type

  return DataPart(mimeType!, await File(path).readAsBytes());
}

String? getMimeType(String filePath) {
  return lookupMimeType(filePath); // Returns a MIME type like 'image/jpeg'
}

}
