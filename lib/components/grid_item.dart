import 'package:disability_helper/services/boxes.dart';
import 'package:disability_helper/services/data_checker.dart';
import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  final Widget page;
  final String title;
  final String image;
  final double imgWidth;
  final double imgHeight;
  final double spaceBetween;
  final bool? isNutrients;

  const GridItem({
    super.key,
    required this.page,
    required this.title,
    required this.image,
    required this.imgWidth,
    required this.imgHeight,
    required this.spaceBetween,
    this.isNutrients,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () async {
            if (isNutrients == true &&
                await isDataExists("Health", boxHealth) == false) {
              await showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                        title: Text("Please Add Your Health Data In Settings"),
                      ));
            } else {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => page));
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0XFF25a0fd),
            ),
            height: 100,
            width: 100,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  Image.asset(
                    image,
                    width: imgWidth,
                    height: imgHeight,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: spaceBetween),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: FittedBox(
                      child: Text(title,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
