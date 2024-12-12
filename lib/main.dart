import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:disability_helper/pages/home_page.dart';
import 'package:disability_helper/services/boxes.dart';
import 'package:disability_helper/services/reminder.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding is initialized
  await Hive.initFlutter();
  
  Hive.registerAdapter(ReminderAdapter());

  boxReminders = await Hive.openBox<Reminder>('reminderBox');
  
  boxPhones= await Hive.openBox('phoneBox');


   await AwesomeNotifications().initialize(
    null, // Specify the default app icon
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Medicine Notification',
        channelDescription: 'Notification channel for medicine reminders',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      ),
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Disability Helper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}