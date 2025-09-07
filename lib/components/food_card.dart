import 'package:disability_helper/pages/food_detail_page.dart';
import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final double screenWidth;

  const FoodCard({required this.item, required this.screenWidth, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FoodDetailPage(item: item),
      )),
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Material(
          color: Colors.white,
          elevation: 5,
          borderRadius: BorderRadius.circular(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Material(
                borderRadius: BorderRadius.circular(8),
                elevation: 5,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      item['imagePath'],
                      height: screenWidth > 600 ? 280 : 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  item['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
