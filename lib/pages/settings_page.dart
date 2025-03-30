import 'package:advanced_chips_input/advanced_chips_input.dart';
import 'package:disability_helper/services/boxes.dart';
import 'package:disability_helper/services/health.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController phoneController = TextEditingController();

  List<String>? _allergies = [];
  List<String>? _diseases = [];
  TextEditingController ageController = TextEditingController();

  String _selectedGender = "Male";

  @override
  void initState() {
    // boxPhones.clear();
    // boxReminders.clear();
    super.initState();
  }

  bool isMale(String gender) => gender == "Male";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildEmergencyContacts(),
              const SizedBox(height: 10),
              Divider(color: Colors.lightBlue[200], thickness: 4),
              const SizedBox(height: 10),
              buildHealthForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmergencyContacts() {
    return Column(children: [
      Center(
          child: Container(
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Emergency Number",
              style: Theme.of(context).textTheme.headlineLarge),
        ),
      )),
      const SizedBox(
        height: 20,
      ),
      TextFormField(
        controller: phoneController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Enter An Emergency phone Number",
          labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      GestureDetector(
        onTap: () async {
          if (phoneController.text.isNotEmpty) {
            addPhoneNUmber(phoneController.text);
          } else {
            await showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                      title: Text("Please enter a phone number"),
                    ));
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
              child: Text("Add Phone Number",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20))),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      GestureDetector(
        onTap: () async {
          await boxPhones.clear();
          showDialog(
              context: context,
              builder: (context) =>
                  const AlertDialog(title: Text("Emergency Number Reset")));
        },
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.red.shade500,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
              child: Text("Reset Emergency Number",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20))),
        ),
      ),
    ]);
  }

  Widget buildHealthForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Center(
          child: Container(
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text("Health Details",
              style: Theme.of(context).textTheme.headlineLarge),
        ),
      )),
      const SizedBox(
        height: 20,
      ),
      const Text(
        "*Press Enter To Submit",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      const SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Allergies. If There Is Any",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      genderWidget(),
      const SizedBox(height: 10),
      TextFormField(
        controller: ageController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lightBlue, width: 2.0)),
          label: Text("Age",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const Icon(Icons.male),
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const Icon(Icons.female),
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
        builder: (context) => const AlertDialog(title: Text("Health Added")));
  }

  Future<void> addPhoneNUmber(String number) async {
    print("adding");
    if (boxPhones.containsKey("EmergencyNumber")) {
      boxPhones.delete("EmergencyNumber");
    }
    await boxPhones.put("EmergencyNumber", number);
    showDialog(
        context: context,
        builder: (context) =>
            const AlertDialog(title: Text("Phone Number Added")));
    phoneController.clear();
  }
}
