import 'package:disability_helper/components/emergency_option_tile.dart';
import 'package:disability_helper/services/boxes.dart';
import 'package:disability_helper/services/data_checker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> emergencyPopup(BuildContext context) async {
  bool exists = await isDataExists("EmergencyNumber", boxPhones);
  if (exists) {
    var phoneNumber = boxPhones.get("EmergencyNumber");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose an Option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EmergencyOptionTile(
                icon: Icons.call,
                iconColor: Colors.green,
                title: "Call $phoneNumber",
                onTap: () async {
                  Uri uri = Uri(scheme: 'tel', path: phoneNumber);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    _showErrorDialog(context, "Cannot make call");
                  }
                },
              ),
              EmergencyOptionTile(
                icon: Icons.sms,
                iconColor: Colors.blue,
                title: "Send Location to $phoneNumber",
                onTap: () async {
                  _sendLocation(context, phoneNumber);
                },
              ),
            ],
          ),
        );
      },
    );
  } else {
    _showErrorDialog(context, "Please enter a phone number in settings");
  }
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(message),
    ),
  );
}

Future<void> _sendSMS(String message, String phoneNumber) async {
  final Uri smsUri = Uri(
    scheme: 'sms',
    path: phoneNumber,
    queryParameters: {
      'body': message,
    },
  );

  if (await canLaunchUrl(smsUri)) {
    await launchUrl(smsUri);
  } else {
    throw Exception('Could not launch SMS');
  }
}

Future<void> _sendLocation(BuildContext context, String phoneNumber) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  try {
    final position = await getUserLocation(context);
    final locationURL =
        'https://www.google.com/maps/place/${position.latitude},${position.longitude}';
    await _sendSMS(
      "Emergency! My location: $locationURL",
      phoneNumber,
    );
  } catch (e) {
    _showErrorDialog(context, "Error: $e");
  } finally {
    Navigator.pop(context); // Close the loading dialog
  }
}

Future<Position> getUserLocation(BuildContext context) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    _showErrorDialog(context, "Location service is disabled");
    return Future.error("Location service is disabled");
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      _showErrorDialog(context, "Location permission is denied");
      return Future.error("Location permission is denied");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    _showErrorDialog(context, "Location permission is permanently denied");
    return Future.error("Location permission is permanently denied");
  }

  return await Geolocator.getCurrentPosition();
}