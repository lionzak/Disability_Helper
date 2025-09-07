import 'package:advanced_chips_input/advanced_chips_input.dart';
import 'package:disability_helper/components/setting_header.dart';
import 'package:disability_helper/consts.dart';
import 'package:disability_helper/services/boxes.dart';
import 'package:disability_helper/services/health.dart';
import 'package:flutter/material.dart';

class HealthDetailsPage extends StatefulWidget {
  const HealthDetailsPage({super.key});

  @override
  State<HealthDetailsPage> createState() => _HealthDetailsPageState();
}

class _HealthDetailsPageState extends State<HealthDetailsPage> {
  List<String>? _allergies = [];
  List<String>? _diseases = [];
  TextEditingController ageController = TextEditingController();

  String _selectedGender = "Male";

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FLOATING_BUTTON,
        appBar: AppBar(
            title: const Text("Health Details"),
            centerTitle: true,
            backgroundColor: BTN_COLOR,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back))),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(color: BG_COLOR),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: buildHealthForm(),
              )
            ],
          ),
        ));
  }

  bool isMale(String gender) => gender == "Male";

  Widget buildHealthForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
     const SettingHeader(title: "Health Details"),
      const SizedBox(
        height: 20,
      ),
      const Text(
        "*Press Enter To Submit",
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: TEXT_COLOR),
      ),
      const SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Allergies. If There Is Any",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: TEXT_COLOR),
            ),
          ],
        ),
      ),
      AdvancedChipsInput(
        onSubmitted: (data) {
          _allergies = data.split(' ');
          setState(() {});
        },
        textFormFieldStyle: const TextFormFieldStyle(
          decoration: InputDecoration(
              label: Text(
            "Allergies",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: TEXT_COLOR),
          )),
        ),
        deleteIcon: const Icon(
          Icons.clear,
          color: Colors.white,
          size: 20,
        ),
        separatorCharacter: ' ',
        placeChipsSectionAbove: true,
        widgetContainerDecoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        chipContainerDecoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        chipTextStyle: const TextStyle(color: Colors.white),
        validateInput: true,
        validateInputMethod: (value) {
          if (value.length < 3) {
            return 'Input should be at least 3 characters long';
          }
          return null;
        },
      ),
      const SizedBox(
        height: 10,
      ),
      const SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Diseases. If There Is Any",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: TEXT_COLOR),
            ),
          ],
        ),
      ),
      AdvancedChipsInput(
        
        onSubmitted: (data) {
          _diseases = data.split(' ');
          setState(() {});
        },
        textFormFieldStyle: const TextFormFieldStyle(
          
          decoration: InputDecoration(
            
              label: Text(
            "Diseases",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: TEXT_COLOR),
          )),
        ),
        deleteIcon: const Icon(
          Icons.clear,
          color: Colors.white,
          size: 20,
        ),
        separatorCharacter: ' ',
        placeChipsSectionAbove: true,
        widgetContainerDecoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        chipContainerDecoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        chipTextStyle: const TextStyle(color: Colors.white),
        validateInput: true,
        validateInputMethod: (value) {
          if (value.length < 3) {
            return 'Input should be at least 3 characters long';
          }
          return null;
        },
      ),
      const SizedBox(
        height: 10,
      ),
      const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Gender",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: TEXT_COLOR),
          ),
        ],
      ),
      genderWidget(),
      const SizedBox(height: 10),
      TextFormField(
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: TEXT_COLOR),
        controller: ageController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lightBlue, width: 2.0)),
          label: Text("Age",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: TEXT_COLOR)),
        ),
      ),
      const Divider(),
      const SizedBox(height: 20),
      GestureDetector(
        onTap: () async {
          if (ageController.text.isNotEmpty) {
            await addHealthData(
                age: int.parse(ageController.text),
                isMale: isMale(_selectedGender),
                allergies: _allergies,
                diseases: _diseases);
          } else {
            await showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                        title: Text(
                      "Please Enter Your Age",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    )));
          }
        },
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
              child: Text("Add Health Details",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20))),
        ),
      ),
    ]);
  }

  Widget genderWidget() {
    return Row(
      children: [
        Radio(
          value: 'Male',
          groupValue: _selectedGender,
          onChanged: (value) {
            setState(() {
              _selectedGender = value!;
            });
          },
        ),
        const Text(
          'Male',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: TEXT_COLOR),
        ),
        const Icon(Icons.male, color: Colors.blue),
        Radio(
          value: 'Female',
          groupValue: _selectedGender,
          onChanged: (value) {
            setState(() {
              _selectedGender = value!;
            });
          },
        ),
        const Text(
          'Female',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: TEXT_COLOR),
        ),
        const Icon(Icons.female, color: Colors.pink),
      ],
    );
  }

  Future<void> addHealthData(
      {List<String>? allergies,
      List<String>? diseases,
      required int age,
      required bool isMale}) async {
    Health health = Health(
      allergies: allergies,
      diseases: diseases,
      age: age,
      isMale: isMale,
    );
    if (boxHealth.containsKey("Health")) {
      boxHealth.delete("Health");
    }
    await boxHealth.put("Health", health);
    showDialog(
        context: context,
        builder: (context) =>
            const AlertDialog(title: Text("Health Details Added")));
  }
}
