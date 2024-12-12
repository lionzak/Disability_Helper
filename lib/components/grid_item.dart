import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  final Widget page;
  final String title;
  final String image;
  final double imgWidth;
  final double imgHeight;
  final double spaceBetween;

  const GridItem(
      {super.key,
      required this.page,
      required this.title,
      required this.image,
      required this.imgWidth,
      required this.imgHeight,
      required this.spaceBetween});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => page)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0XFF5171A5),
            ),
            height: 100,
            width: 100,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                children: [
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
