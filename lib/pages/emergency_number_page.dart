import 'package:disability_helper/components/build_button.dart';
import 'package:disability_helper/components/setting_header.dart';
import 'package:disability_helper/consts.dart';
import 'package:disability_helper/services/boxes.dart';
import 'package:flutter/material.dart';

class EmergencyNumberPage extends StatefulWidget {
  const EmergencyNumberPage({super.key});

  @override
  State<EmergencyNumberPage> createState() => _EmergencyNumberPageState();
}

class _EmergencyNumberPageState extends State<EmergencyNumberPage> {
  TextEditingController phoneController = TextEditingController();
  Color resetButtonColor = Colors.transparent;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Emergency Number"),
          centerTitle: true,
          backgroundColor: BTN_COLOR,
        ),
        floatingActionButton: FLOATING_BUTTON,
        body: Stack(children: [
          Container(
            decoration: const BoxDecoration(color: BG_COLOR),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              const SettingHeader(title: "Emergency Number"),
              const SizedBox(
                height: 20,
              ),
              TextField(
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                controller: phoneController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter An Emergency phone Number..",
                  labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              buildButton(
                  text: "Add Phone Number",
                  onPress: () async {
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
                  color: Colors.lightBlue,
                  context: context),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  if (boxPhones.isEmpty) {
                    await showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                              title: Text("No Emergency Number Found"),
                            ));
                    return;
                  }
                  setState(() {
                    resetButtonColor = Colors.red;
                    Future.delayed(const Duration(milliseconds: 250), () {
                      setState(() => resetButtonColor =
                          Colors.transparent); // Revert after delay
                    });
                  });
                  await boxPhones.clear();
                  showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                          title: Text("Emergency Number Reset")));
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: resetButtonColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  child: const Center(
                      child: Text("Reset Emergency Number",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20))),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Future<void> addPhoneNUmber(String number) async {
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
