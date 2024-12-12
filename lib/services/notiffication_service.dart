import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  // Initialize Awesome Notifications
  // Future<void> initNotifications() async {
  //   AwesomeNotifications().initialize(
  //     null, // No custom icon
  //     [
  //       NotificationChannel(
  //         channelKey: 'basic_channel',
  //         channelName: 'Basic notifications',
  //         channelDescription: 'Notification channel for basic notifications',
  //         defaultColor: const Color(0xFF9D50DD), // Customize color
  //         ledColor: Colors.white,
  //       ),
  //     ],
  //   );
  // }



  Future<void> scheduleDailyNotification(
      String title, String body, int hour, int minute, int notificationId) async {

    // Schedule the notification
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        second: 0,
        millisecond: 0,
        repeats: true, // Ensures it repeats daily
      ),
    );
  }


  // Future<void> scheduleNotification(
  //     String title, String body, int secondsFromNow, int notificationId) async {
  //   // Schedule a notification
  //   await AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: notificationId,
  //       channelKey: 'basic_channel',
  //       title: title,
  //       body: body,
  //       notificationLayout: NotificationLayout.Default,
  //     ),
  //     schedule: NotificationInterval(
  //       interval: Duration(seconds: secondsFromNow),
  //       timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
  //       repeats: true,
  //     ),
  //   );
  // }

  // Show notification with dynamic title and body
  // Future<void> showNotification(String title, String body) async {
  //   AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: 10,
  //       channelKey: 'basic_channel',
  //       title: title, // Dynamic title
  //       body: body,   // Dynamic body
  //     ),
  //   );
  // }

  // Schedule notification for a specific time each day with dynamic title and body
  // Future<void> scheduleDailyNotification(TimeOfDay timeOfDay, String title, String body, int id) async {
  //   final currentTime = DateTime.now();
  //   final scheduledTime = DateTime(currentTime.year, currentTime.month, currentTime.day, timeOfDay.hour, timeOfDay.minute);

  //   if (scheduledTime.isBefore(currentTime)) {
  //     // If the time has already passed for today, schedule for tomorrow
  //     scheduledTime.add(const Duration(days: 1));
  //   }

  //   // Create the notification with dynamic content
  //   AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: id,
  //       channelKey: 'basic_channel',
  //       title: title,  // Dynamic title
  //       body: body,    // Dynamic body
  //     ),
  //     schedule: NotificationCalendar.fromDate(date: scheduledTime),
  //   );
  // }

  // Cancel a specific notification by ID
  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}
