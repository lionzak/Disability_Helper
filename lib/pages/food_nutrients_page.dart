import 'package:disability_helper/components/food_card.dart';
import 'package:disability_helper/consts.dart';
import 'package:disability_helper/pages/food_detail_page.dart';
import 'package:flutter/material.dart';

class FoodNutrientsPage extends StatefulWidget {
  const FoodNutrientsPage({super.key});

  @override
  State<FoodNutrientsPage> createState() => _FoodNutrientsPageState();
}

class _FoodNutrientsPageState extends State<FoodNutrientsPage> {
  List<Map<String, dynamic>> foundFoods = [];

  @override
  void initState() {
    foundFoods = foodList;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      foundFoods = enteredKeyword.isEmpty
          ? foodList
          : foodList
              .where((element) => element['name']
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
              .toList();
    });
  }

  

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: BG_COLOR,
      appBar: AppBar(
        title: const Text("Food Nutrients"),
        centerTitle: true,
        backgroundColor: BTN_COLOR,
      ),
      floatingActionButton: FLOATING_BUTTON,
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 20),
          TextField(
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            onChanged: (value) => _runFilter(value),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Search',
              labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              suffixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          buildButton(
              text: "Check A Specific Food",
              onPress: () => showDialog(
                  context: context,
                  builder: (context) {
                    TextEditingController controller = TextEditingController();
                    return AlertDialog(
                      title: const Text(
                        "Search For A Food",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      content:
                          Column(mainAxisSize: MainAxisSize.min, children: [
                        TextField(
                          autofocus: true,
                          controller: controller,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter the name of the food',
                          ),
                        ),
                        const SizedBox(height: 20),
                        buildButton(
                            text: "Search",
                            onPress: () {
                              Navigator.of(context).pop();
                              if (controller.text.isNotEmpty) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FoodDetailPage(
                                        item: {"name": controller.text})));
                              }
                            })
                      ]),
                    );
                  })),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                children: foundFoods.map((item) {
                  return FoodCard(
                    item: item,
                    screenWidth: screenWidth,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }

  Widget buildButton({String? text, VoidCallback? onPress}) {
    return GestureDetector(
      onTap: () => onPress!(),
      child: Center(
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
