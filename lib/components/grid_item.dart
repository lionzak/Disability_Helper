import 'package:disability_helper/consts.dart';
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
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
        padding: EdgeInsets.all(
            screenWidth > 600 ? 20 : 10), // Set padding based on screen width

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
              color: Colors.white,
            ),
            height: 1,
            width: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: FittedBox(
                      child: Text(title,
                          style: TextStyle(
                              color: TEXT_COLOR2,
                              fontSize: screenWidth > 600 ? 30 : 28,
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
