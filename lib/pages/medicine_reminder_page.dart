import 'package:disability_helper/components/emergency_popup.dart';
import 'package:disability_helper/services/boxes.dart';
import 'package:disability_helper/services/notiffication_service.dart';
import 'package:disability_helper/services/reminder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

class MedicineReminderPage extends StatefulWidget {
  const MedicineReminderPage({super.key});

  @override
  State<MedicineReminderPage> createState() => _MedicineReminderPageState();
}

class _MedicineReminderPageState extends State<MedicineReminderPage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  DateTime? pickedDate = DateTime.now();
  int dosageCount = 1;
  int selectedInTakeIndex = 0;

  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicine Reminder"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await emergencyPopup(context);
        },
        child: const Icon(
          Icons.sos_sharp,
          size: 30,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(color: Color(0XFFb3dfff)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          label: Text("Time "),
                          labelStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          filled: true,
                          prefixIcon: Icon(Icons.timer),
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                        ),
                        readOnly: true,
                        onTap: _showTimePicker,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          label: Text("Title"),
                          labelStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          filled: true,
                          prefixIcon: Icon(Icons.title),
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          "Dosage",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (dosageCount > 1) {
                            setState(() {
                              dosageCount--;
                            });
                          }
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black),
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        dosageCount.toString(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            dosageCount++;
                          });
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      const Text(
                        "In-Take",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const Spacer(),
                      CupertinoSegmentedControl(
                        children: const {
                          0: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Before Food',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          1: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'After Food',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        },
                        onValueChanged: (int newValue) {
                          setState(() {
                            selectedInTakeIndex = newValue;
                          });
                        },
                        groupValue: selectedInTakeIndex,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: buildButton(
                      "Set Reminder",
                      () {
                        if (dateController.text.isEmpty ||
                            titleController.text.isEmpty) {
                          showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                  title: Text("Please Enter Full Data")));
                          return;
                        }
                        setState(() {
                          final notificationId = DateTime.now()
                              .millisecondsSinceEpoch
                              .remainder(100000); // Unique ID
                          boxReminders.add(Reminder(
                              title: titleController.text,
                              date: pickedDate!,
                              notificationId: notificationId,
                              dosage: dosageCount,
                              beforeFood: selectedInTakeIndex == 0));

                          notificationService.scheduleDailyNotification(
                              titleController.text,
                              "Daily Reminder for ${titleController.text}, With $dosageCount Dosage(s) at ${_formatTime(TimeOfDay(hour: pickedDate!.hour, minute: pickedDate!.minute))}, ${selectedInTakeIndex == 0 ? "Before Food" : "After Food"}",
                              pickedDate!.hour,
                              pickedDate!.minute,
                              notificationId); // Schedule the notification with dynamic title and body

                          titleController.clear();
                          dateController.clear();
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                        valueListenable: boxReminders.listenable(),
                        builder: (context, dynamic box, _) {
                          return ListView.builder(
                            itemCount: box.length,
                            itemBuilder: (context, index) {
                              Reminder reminder = box.getAt(index)!;
                              return ListTile(
                                leading: IconButton(
                                  onPressed: () {
                                    _removeReminder(index, reminder);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Center(
                                          child: Text("Reminder Deleted",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20))),
                                      backgroundColor: Colors.lightBlue,
                                    ));
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                ),
                                titleTextStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(reminder.title),
                                ),
                                subtitleTextStyle: const TextStyle(
                                    fontSize: 17, color: Colors.black),
                                subtitle: Text(
                                  "Daily Reminder for ${reminder.title}, With ${reminder.dosage} Dosage(s) at ${_formatTime(TimeOfDay(hour: pickedDate!.hour, minute: pickedDate!.minute))}, ${reminder.beforeFood == true ? "Before Food" : "After Food"}",
                                ),
                              );
                            },
                          );
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      // Create a DateTime object from the selected time
      dateController.text = selectedTime.format(context);
      pickedDate = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectedTime.hour,
        selectedTime.minute,
      );
    }
  }

  int generateRandomId() {
    final Random random = Random();
    return random
        .nextInt(1000000); // Generates a random ID between 0 and 999,999
  }

  void _removeReminder(int index, Reminder reminder) async {
    // Cancel the corresponding notification
    await notificationService.cancelNotification(reminder.notificationId);

    // Remove the reminder from Hive
    boxReminders.deleteAt(index);
  }

  Widget buildButton(String text, VoidCallback? onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Text(text,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20))),
      ),
    );
  }
}

void _sendSMS(String message, double latitude, double longitude,
    List<String> recipents, BuildContext context) async {
  final Uri smsUri = Uri(
    scheme: 'sms',
    path: boxPhones
        .get("EmergencyNumber"), // Replace with the recipient's phone number

    queryParameters: {
      'body':
          'Emergency! My location: https://www.google.com/maps/place/$latitude,$longitude',
    },
  );

  if (await canLaunchUrl(smsUri)) {
    await launchUrl(smsUri);
  } else {
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              title: Text("Could not launch SMS"),
            ));
  }
}

Future<Position> getUserLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error("Location service is disabled");
  }
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error("Location permission are denied");
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        "Location permissions are permanently denied, we cannot request permissions");
  }
  return await Geolocator.getCurrentPosition();
}

// Helper method to format TimeOfDay into 12-hour format
String _formatTime(TimeOfDay time) {
  final DateTime dateTime = DateTime(0, 0, 0, time.hour, time.minute);
  final DateFormat formatter =
      DateFormat('hh:mm a'); // 12-hour format with AM/PM
  return formatter.format(dateTime);
}
