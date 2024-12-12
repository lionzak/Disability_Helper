import 'package:disability_helper/services/boxes.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    // boxPhones.clear();
    // boxReminders.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              onTap: () => print("asdasd ${phoneController.text}"),
              controller: phoneController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter An Emergency phone Number",
                labelStyle:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                print("asd ${phoneController.text}");
                if (phoneController.text.isNotEmpty) {
                  addPhoneNUmber(phoneController.text);
                  print("awsdasd");
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
          ],
        ),
      ),
    );
  }

  Future<void> addPhoneNUmber(String number) async {
    print("adding");
    if(boxPhones.containsKey("EmergencyNumber")){boxPhones.delete("EmergencyNumber");}
    await boxPhones.put("EmergencyNumber", number);
    showDialog(
        context: context,
        builder: (context) =>
            const AlertDialog(title: Text("Phone Number Added")));
    phoneController.clear();
  }
}
