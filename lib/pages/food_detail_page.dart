import 'dart:async';
import 'package:disability_helper/services/boxes.dart';
import 'package:disability_helper/services/gemini.dart';
import 'package:disability_helper/services/health.dart';
import 'package:flutter/material.dart';

class FoodDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const FoodDetailPage({super.key, required this.item});

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  GeminiService geminiService = GeminiService();
  final TextEditingController weightController = TextEditingController();
  String score = "...";
  String nutrition = "...";

  Timer? _timer;

  String addColonToString(String input) {
    RegExp regexEndWord = RegExp(r'(\b\w+)(?=\d[^\s])');
    RegExp regexBetweenNumber = RegExp(r'(\d+)([^\d\s])');

    String result = input;

    result =
        result.replaceAllMapped(regexEndWord, (match) => "${match.group(1)}:");

    result = result.replaceAllMapped(
        regexBetweenNumber, (match) => "${match.group(1)}:${match.group(2)}");

    return result;
  }

  String parseAndFormatString(String input) {
    List<String> parts = input.split(', ').map((part) => part.trim()).toList();

    return parts.join('\n');
  }

  Future<void> updateScore() async {
    setState(() {
      score = "Loading";
      nutrition = "Loading";
    });
    Health health = boxHealth.get("Health");
    String allergies = health.allergies!
        .where((allergy) => allergy.isNotEmpty)
        .map((allergy) => '$allergy allergy')
        .join(", ");
    String diseases = health.diseases!.join(", ");

    score = await geminiService.sendToGemini(
        "very short answer with no added details: score what will i ask from bad , ok or preferable: can a ${health.age}yrs old ${health.isMale ? "male" : "female"} person with ${diseases.isNotEmpty ? diseases : "No diseases"}  and with ${allergies.isNotEmpty ? allergies : "No allergies"}, eat ${weightController.text} gm of ${widget.item["name"]}",
        context);

    nutrition = await geminiService.sendToGemini(
        "very short answer with no added details: give me three nutrition facts about ${weightController.text} grams of ${widget.item["name"]} , and the facts that i want are sugar, calcium and fats",
        context);
    nutrition = parseAndFormatString(nutrition);
    setState(() {
      score = score.replaceAll(RegExp(r'[. ,;:]'), '');
      nutrition = nutrition.replaceAll(RegExp(r'[,;]'), '');
    });
  }

  Icon parseScoreIcon(String score) {
    switch (score.toLowerCase().replaceAll(RegExp(r'\s+'), "")) {
      case "bad":
        return const Icon(
          Icons.thumb_down,
          color: Colors.red,
          size: 40,
        );
      case "ok":
        return const Icon(
          Icons.thumb_up,
          color: Colors.green,
          size: 40,
        );

      case "preferable":
        return const Icon(
          Icons.star,
          color: Colors.amber,
          size: 40,
        );
      default:
        return const Icon(
          Icons.rotate_right_rounded,
          size: 40,
        );
    }
  }

  @override
  void dispose() {
    super.dispose();
    weightController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.item["imagePath"] != null
                    ? Container(
                        margin: const EdgeInsets.all(5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            widget.item["imagePath"],
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height /
                                3, // Adjusted height
                            fit:
                                BoxFit.cover, // Changed to cover for better fit
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(height: 20),
                Text(
                  "${widget.item["name"]}",
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2, // Limit the number of lines
                  overflow: TextOverflow.ellipsis, // Handle overflow
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Weight:",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          TextField(
                            controller: weightController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.lightBlue),
                              ),
                              label: Text("Weight In Gram"),
                              labelStyle: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              if (weightController.text.trim() != "" &&
                                  !weightController.text
                                      .contains(RegExp(r'^\s*$')) &&
                                  !weightController.text
                                      .trim()
                                      .contains(RegExp(r'^0+$'))) {
                                setState(() {
                                  updateScore();
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10)),
                              width: double.infinity,
                              height: 50,
                              child: const Center(
                                  child: Text(
                                "Search",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              )),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                      child: Column(
                        children: [
                          const Center(
                            child: Text(
                              "Score:",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Center(
                            child: Text(score.replaceAll(RegExp(r'\s+'), ""),
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                          ),
                          parseScoreIcon(score),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text("Nutrition Facts:",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(nutrition,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
