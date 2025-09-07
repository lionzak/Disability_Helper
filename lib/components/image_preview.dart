import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePreview extends StatelessWidget {
  final XFile? imageFile;

  const ImagePreview({required this.imageFile, super.key});

  @override
  Widget build(BuildContext context) {
    return imageFile != null
        ? SizedBox(
            height: MediaQuery.of(context).size.height / 3.4,
            child: Image.file(
              File(imageFile!.path),
              fit: BoxFit.cover,
            ),
          )
        : Container(
            decoration: const BoxDecoration(color: Colors.white),
            height: MediaQuery.of(context).size.height / 3.4,
          );
  }
}