import 'package:disability_helper/components/build_button.dart';
import 'package:disability_helper/services/notiffication_service.dart';
import 'package:disability_helper/services/reminder.dart';
import 'package:disability_helper/services/boxes.dart';
import 'package:disability_helper/consts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicineReminderPage extends StatefulWidget {
  const MedicineReminderPage({super.key});

  @override
  State<MedicineReminderPage> createState() => _MedicineReminderPageState();
}

class _MedicineReminderPageState extends State<MedicineReminderPage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  DateTime? pickedDate = DateTime.now();
  int dosageCount = 1;
  int selectedInTakeIndex = 0;

  NotificationService notificationService = NotificationService();

  @override
  void dispose() {
    titleController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicine Reminder"),
        centerTitle: true,
        backgroundColor: BTN_COLOR,
      ),
      floatingActionButton: FLOATING_BUTTON,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(color: BG_COLOR),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  buildTextField(
                    label: "Time",
                    icon: Icons.timer,
                    controller: dateController,
                    readOnly: true,
                    onTap: _showTimePicker,
                  ),
                  const SizedBox(height: 20),
                  buildTextField(
                    label: "Title",
                    icon: Icons.title,
                    controller: titleController,
                  ),
                  const SizedBox(height: 20),
                  buildDosageControl(),
                  const SizedBox(height: 20),
                  buildInTakeControl(),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: buildButton(
                      context: context,
                      color: BTN_COLOR,
                      text: "Set Reminder",
                      onPress: () {
                        if (dateController.text.isEmpty ||
                            titleController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) => const AlertDialog(
                              title: Text("Please Enter Full Data"),
                            ),
                          );
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
                            beforeFood: selectedInTakeIndex == 0,
                          ));

                          notificationService.scheduleDailyNotification(
                            titleController.text,
                            "Daily Reminder for ${titleController.text}, With $dosageCount Dosage(s) at ${_formatTime(TimeOfDay(hour: pickedDate!.hour, minute: pickedDate!.minute))}, ${selectedInTakeIndex == 0 ? "Before Food" : "After Food"}",
                            pickedDate!.hour,
                            pickedDate!.minute,
                            notificationId,
                          );

                          titleController.clear();
                          dateController.clear();
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: boxReminders.listenable(),
                      builder: (context, dynamic box, _) {
                        return ListView.builder(
                          itemCount: box.length,
                          itemBuilder: (context, index) {
                            Reminder reminder = box.getAt(index)!;
                            return buildReminderTile(reminder, index);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
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

  void _removeReminder(int index, Reminder reminder) async {
    await notificationService.cancelNotification(reminder.notificationId);
    boxReminders.deleteAt(index);
  }

  Widget buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          label: Text(label),
          labelStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          prefixIcon: Icon(icon),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  Widget buildDosageControl() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 30),
          child: Text(
            "Dosage",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white,
            ),
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
              color: BTN_COLOR,
            ),
            child: const Icon(
              Icons.remove,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          dosageCount.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
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
              color: BTN_COLOR,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget buildInTakeControl() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 30),
        const Text(
          "In-Take",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        CupertinoSegmentedControl(
          children: const {
            0: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Before Food',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            1: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'After Food',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
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
    );
  }

  Widget buildReminderTile(Reminder reminder, int index) {
    return ListTile(
      leading: IconButton(
        onPressed: () {
          _removeReminder(index, reminder);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(
                child: Text(
                  "Reminder Deleted",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              backgroundColor: Colors.lightBlue,
            ),
          );
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
        color: Colors.white,
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(reminder.title),
      ),
      subtitleTextStyle: const TextStyle(
        fontSize: 17,
        color: Colors.white,
      ),
      subtitle: Text(
        "Daily Reminder for ${reminder.title}, With ${reminder.dosage} Dosage(s) at ${_formatTime(TimeOfDay(hour: pickedDate!.hour, minute: pickedDate!.minute))}, ${reminder.beforeFood == true ? "Before Food" : "After Food"}",
      ),
    );
  }
}


// Helper method to format TimeOfDay into 12-hour format
String _formatTime(TimeOfDay time) {
  final DateTime dateTime = DateTime(0, 0, 0, time.hour, time.minute);
  final DateFormat formatter =
      DateFormat('hh:mm a'); // 12-hour format with AM/PM
  return formatter.format(dateTime);
}
