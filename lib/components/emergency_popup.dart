import 'package:disability_helper/services/boxes.dart';
import 'package:disability_helper/services/data_checker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> emergencyPopup(BuildContext context) async {
  bool exists = await isDataExists("EmergencyNumber", boxPhones);
  if (exists) {
    print(boxPhones.get("EmergencyNumber"));
    var phoneNumber = boxPhones.get("EmergencyNumber");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose an Option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300,
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.call,
                    color: Colors.green,
                    size: 35,
                  ),
                  title: Text(
                    "Call $phoneNumber",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  onTap: () async {
                    // Call logic
                    Uri uri = Uri(
                        scheme: 'tel', path: boxPhones.get("EmergencyNumber"));
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      // ignore: use_build_context_synchronously
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              title: Text("Cannot make call"),
                            );
                          });
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(
                    Icons.sms,
                    color: Colors.blue,
                    size: 35,
                  ),
                  title: Text(
                    "Send Location to $phoneNumber",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  onTap: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    try {
                      await getUserLocation(context).then((value) {
                        final locationURL =
                            'https://www.google.com/maps/place/${value.latitude},${value.longitude}';
                        _sendSMS(
                            "Emergency MY location: $locationURL",
                            value.latitude,
                            value.longitude,
                            [boxPhones.get("EmergencyNumber")]);
                      });
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Error $e"),
                            );
                          });
                    } finally {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  } else {
    await showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              title: Text("Please enter a phone number in settings"),
            ));
  }
}

void _sendSMS(String message, double latitude, double longitude,
    List<String> recipents) async {
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
    print("Could not launch SMS");
    throw Exception('Could not launch SMS');
  }
}

Future<Position> getUserLocation(BuildContext context) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await showDialog(
        context: context,
        builder: (context) =>
            const AlertDialog(title: Text("Location service is disabled")));
    return Future.error("Location service is disabled");
  }
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      await showDialog(
          context: context,
          builder: (context) =>
              const AlertDialog(title: Text("Location service is Denied")));
      return Future.error("Location permission are denied");
    }
  }
  if (permission == LocationPermission.deniedForever) {
    await showDialog(
        context: context,
        builder: (context) => const AlertDialog(
            title: Text("Location service is Denied Forever")));
    return Future.error(
        "Location permissions are permanently denied, we cannot request permissions");
  }
  return await Geolocator.getCurrentPosition();
}
