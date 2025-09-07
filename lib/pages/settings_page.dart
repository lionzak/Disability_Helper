import 'package:disability_helper/components/setting_tile.dart';
import 'package:disability_helper/pages/emergency_number_page.dart';
import 'package:disability_helper/pages/health_details_page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SettingTile(
              title: "Emergency Number",
              icon: const Icon(
                Icons.call,
                color: Colors.greenAccent,
                size: 35,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const EmergencyNumberPage()));
              },
            ),
            SettingTile(
              title: "Health Details",
              icon: Icon(Icons.document_scanner_outlined,
                  size: 35, color: Colors.blue[900]),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HealthDetailsPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
